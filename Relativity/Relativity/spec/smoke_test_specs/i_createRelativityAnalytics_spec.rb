require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Create new Relativity Analytics index" do

	before :all do
		@relativity = Login_N_CreateNewWorkspace.new
		@workspace 	= RelativityWorkspace.new
		$url 				= RelativityUrl.const_get('Automation_forms')

		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")	
	end

	context "Create new Analytics index" do
    before {
      @workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @workspace.TabAccess(ApplicationNames::WorkspaceAdmin)
      @workspace.AnalyticsIndexField(AnalyticsIndexField::Name)
    }

		it "should be able to create new Analytics index" do
      expect($browser.iframe(:id =>'ListTemplateFrame').table(:class => 'itemTable').text).to include(AnalyticsIndexField::Name).and include(AnalyticsIndexField::Status)
 		  @workspace.DeleteAnalytics
    end
  end
end
