require_relative 'spec_helper'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require_relative '../lib/Login_N_CreateNewWorkspace'
require 'byebug'


describe "Adding the internal user and adding the user to the sys admin group" do
	before {
		@login_N_CreateNewWorkspace = Login_N_CreateNewWorkspace.new
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}

	context "When a new relativity environment is created, we need to be able to add a new internal users and assign sys admin as group" do
		
		it "login to Relativity landing page and login in using smoke credentials" do
      @url = RelativityUrl.const_get('Automation_forms')
      $browser.goto @url
      @login_N_CreateNewWorkspace.relativityLogin(AdminLogin::RelAdminUser, AdminLogin::Password)
    	@relativityworkspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
    end
		
		it "should allow a user to create a new User" do
			@automationSmokeTest.createIntUser(
				CreateInternalUsers::UserFirstName,
				CreateInternalUsers::UserLastName,
				CreateInternalUsers::Email,
				CreateInternalUsers::Password)
		end

		it "should allow the internal user to be added to the sys admin group" do
			@automationSmokeTest.addUserToGroup_internal(CreateInternalUsers::FullName)
		end
	end

end