require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Importing test data to the Relativity Smoke Workspace" do
	before {
		@relativity = Login_N_CreateNewWorkspace.new
		@workspace = RelativityWorkspace.new
	}
 	context 'Importing test data using the WorkspaceImportApp' do
 		before {
      $url = RelativityUrl.const_get('Automation_forms')
      $browser.goto $url
			@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
      @relativity.switch_ui("Switch to Classic UI")
    }

    it "Should import the test data file in to the specified workspace" do
    	ArtifactID_new = @workspace.getWorkspaceArtifactID
      WebURI = RelativityUrl::Automation+"webapi/"
      puts ArtifactID_new
      puts WebURI
      $browser.close
      system ("\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\WorkspaceImportApp\\post-install-import -mapping-file \"\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\Post-installation_verification_test_data\\Salt-v-Pepper-kCura-Starter-Template.kwe\" -data-file \"\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\Post-installation_verification_test_data\\Salt-v-Pepper (US date format).dat\" -url #{WebURI} -username relativity.admin@kcura.com -password Test1234! -workspaceID #{ArtifactID_new}")

      exec "post-install-import -mapping-file <mapping file path> -data-file <data file path> [-url <import API URL>]
    	[-username <Relativity username>] [-password <Relativity password>] [-workspace <workspace name>] [-workspaceID <workspace artifact ID>]	"
    end
  end
end
