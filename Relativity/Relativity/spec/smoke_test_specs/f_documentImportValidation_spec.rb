require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require 'byebug'

describe "Validating that the import actually imported documents into the workspace" do
	before {
		@relativityworkspace = RelativityWorkspace.new
	}
 	context 'Getting to the workspace document page' do
 		before {
      $url = RelativityUrl.const_get('Automation_forms')
      $browser.goto $url
      @relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		  @relativity.switch_ui("Switch to Classic UI")	
      @relativityworkspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
      @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @relativityworkspace.TabAccess(ApplicationNames::Documents)
    }

    it "Should have more than 1 document in the workspace" do
      expect(@relativityworkspace.checkDocsloaded).to be > 1
    end
	end
end
