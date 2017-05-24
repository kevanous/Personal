require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require 'byebug'


describe "Adding the Smoke client, matter, user and group" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}

	context "When a new relativity environment is created, we need to be able to add a new client, matter, user and group" do
		before {
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
		}	

		it "should allow the user to create a new Client" do
			@automationSmokeTest.createSmokeClient(CreateSmokeItems::Client)
			#("Smoke Client")
		end

		it "should allow the user to create a new Matter" do
			@automationSmokeTest.createSmokeMatter(CreateSmokeItems::Matter)
			expect($browser.tr(:id=>"_name").td(:text=>CreateSmokeItems::Matter)).to exist
			#("Smoke Matter")
		end

		it "should allow a user to create a new User" do
			@automationSmokeTest.createSmokeUser(
				CreateSmokeItems::UserFirstName,
				CreateSmokeItems::UserLastName,
				CreateSmokeItems::Email,
				CreateSmokeItems::Password)
			#("Smoke", "User", "Smokeuser@kcura.com", "Password2!")
		end

		it "should allow a user to create a new Group" do
			@automationSmokeTest.createSmokeGroup(CreateSmokeItems::GroupName)
		end

		it "should allow the smoke user to be added to the smoke group" do
			@automationSmokeTest.addUserToGroup(CreateSmokeItems::FullName, CreateSmokeItems::GroupName)
			expect($browser.a(:text=>"System Administrators").wait_until_present(5)).to exist
			expect($browser.a(:text=>"Smoke Group").wait_until_present(5)).to exist
			#"User, Smoke", "Smoke Group"
		end
	end

end