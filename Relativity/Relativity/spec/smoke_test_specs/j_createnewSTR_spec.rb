require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Create New STR" do

	before :all do 
		@relativity	 = Login_N_CreateNewWorkspace.new
		@workspace	 = RelativityWorkspace.new

		$url = RelativityUrl.const_get('Automation_forms')
		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")	
	end

	context "Create New STR" do
		before {      
			@workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@workspace.TabAccess(ApplicationNames::Reporting)
			@workspace.STRFieldentry(STR::Name)
		}

		it "should be able to create new STR" do
			expect($browser.iframe(:id =>'ListTemplateFrame').table(:class => 'itemTable').text).to include(STR::Name).and include(STR::Status)
			@workspace.DeleteSTR
		end
	end

end
