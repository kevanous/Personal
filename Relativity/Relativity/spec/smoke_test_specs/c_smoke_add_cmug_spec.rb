require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'


describe "Adding the Smoke client, matter, user and group" do
	before :all do
		@relativity = Login_N_CreateNewWorkspace.new
		@workspace 	= RelativityWorkspace.new
		@autoTest 	= AutomationSmokeTest.new

		$url = RelativityUrl.const_get('Automation_forms')
		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")
	end

	context "When a new relativity environment is created, we need to be able to add a new client, matter, user and group" do
		before :each do
			@workspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
		end

		it "Creates new Client" do			
			expect(@autoTest.createSmokeClient(CreateSmokeItems::Client)).to be true
		end

		it "Creates new Matter" do			
			expect(@autoTest.createSmokeMatter(CreateSmokeItems::Matter)).to be true
		end

		it "Creates new User" do			
			expect(@autoTest.createSmokeUser(CreateSmokeItems::UserFirstName,CreateSmokeItems::UserLastName,CreateSmokeItems::Email,CreateSmokeItems::Password,CreateSmokeItems::FullName)).to be true
		end


		it "Creates New Group" do			
			expect(@autoTest.createSmokeGroup(CreateSmokeItems::GroupName)).to be true
		end

		it "Add User to Group" do			
			expect(@autoTest.addUserToGroup(CreateSmokeItems::FullName, CreateSmokeItems::GroupName)).to be true			
		end
	end

end
