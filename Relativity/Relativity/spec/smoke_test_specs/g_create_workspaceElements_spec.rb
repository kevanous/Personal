require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Create a new workspace elements" do
	before :all do
		@relativity = Login_N_CreateNewWorkspace.new
		@workspace 	= RelativityWorkspace.new
		@autoTest	= AutomationSmokeTest.new
		$url 		= RelativityUrl.const_get('Automation_forms') 
		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")	
	end

	context "Accessing Relativity Workspace Admin tab" do
		before {			
			@workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@workspace.TabAccess(ApplicationNames::WorkspaceAdmin)
		}

		it "should allow the user to create a new field" do
			@autoTest.createNewField(WorkspaceElements::FieldName, WorkspaceElements::FieldType)
		end

		it "should  allow the user to create a new choice" do
			@autoTest.createNewChoices(WorkspaceElements::ChoiceName1, WorkspaceElements::ChoiceName2, WorkspaceElements::FieldName)
		end

		it "should  allow the user to create a new layout" do
			@autoTest.createNewLayout(WorkspaceElements::LayoutName, WorkspaceElements::FieldName)
		end
	end

end
