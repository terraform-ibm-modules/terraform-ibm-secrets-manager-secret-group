// Tests in this file are run in the PR pipeline
package test

import (
	"log"
	"os"
	"testing"
	//"fmt"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

// Use existing resource group
const resourceGroup = "geretain-test-secrets-manager"
const basicExampleTerraformDir = "examples/basic"

// Define a struct with fields that match the structure of the YAML data
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

const bestRegionYAMLPath = "../common-dev-assets/common-go-assets/cloudinfo-region-secmgr-prefs.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, terraformDir string, prefix string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  terraformDir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"existing_sm_instance_guid":   permanentResources["secretsManagerGuid"],
			"existing_sm_instance_region": permanentResources["secretsManagerRegion"],
		},
		// Do not hard fail the test if the implicit destroy steps fail to allow a full destroy of resource to occur
		ImplicitRequired: false,
	})

	return options
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, basicExampleTerraformDir, "sm-group")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgrade(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, basicExampleTerraformDir, "sm-group-upg")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected  some output")
	}

}

func TestPrivateInSchematics(t *testing.T) {
	t.Parallel()

	const testLocation = "examples/private"

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  "sm-sg-private",
		TarIncludePatterns: []string{
			"*.tf",
			testLocation + "/*.tf",
		},
		ResourceGroup:          resourceGroup,
		TemplateFolder:         testLocation,
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 80,
		BestRegionYAMLPath:     bestRegionYAMLPath,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "resource_tags", Value: options.Tags, DataType: "list(string)"},
		{Name: "region", Value: options.Region, DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "existing_sm_instance_crn", Value: permanentResources["privateOnlySecMgrCRN"], DataType: "string"},
		{Name: "existing_sm_instance_region", Value: permanentResources["privateOnlySecMgrRegion"], DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")
}
