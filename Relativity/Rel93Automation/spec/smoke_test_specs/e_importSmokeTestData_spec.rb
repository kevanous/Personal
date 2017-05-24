require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require 'byebug'

describe "Importing test data to the Relativity Smoke Workspace" do
	before {
		@relativityworkspace = RelativityWorkspace.new
	}
 	context 'Importing test data using the WorkspaceImportApp' do
 		before {
      $url = RelativityUrl.const_get($env)
      $browser.goto $url
    }

    it "Should import the test data file in to the specified workspace" do
    	ArtifactID_new = @relativityworkspace.getWorkspaceArtifactID
      WebURI = RelativityUrl::Automation+"webapi/"
      puts ArtifactID_new
      puts WebURI
      $browser.close
      system ("\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\WorkspaceImportApp\\post-install-import -mapping-file \"\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\Post-installation_verification_test_data\\Salt-v-Pepper-kCura-Starter-Template.kwe\" -data-file \"\\\\hlnas00\\tech\\Packages\\SmokeTestDataImport\\Post-installation_verification_test_data\\Salt-v-Pepper (US date format).dat\" -url #{WebURI} -username Smokeuser@kcura.com -password Password2! -workspaceID #{ArtifactID_new}")
      
      # exec "post-install-import -mapping-file <mapping file path> -data-file <data file path> [-url <import API URL>] 
    	# [-username <Relativity username>] [-password <Relativity password>] [-workspace <workspace name>] [-workspaceID <workspace artifact ID>]	"
    end
  end 
end 
