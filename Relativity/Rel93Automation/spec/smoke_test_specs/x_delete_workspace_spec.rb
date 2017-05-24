require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/DeleteSmokeWorkspace'
require 'byebug'

describe "Deleting the Smoke Workspace" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
		@deleteSmokeWorkspace = DeleteSmokeWorkspace.new
	}

	context "Delete dtSearch Smoke Indexes" do
		it "would ensure there is no index called Smoke dtSearch" do
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.smokeWorkspaceAccess("Smoke Workspace_With_Documents")
			# @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@relativityworkspace.TabAccess(ApplicationNames::WorkspaceAdmin)
			@deleteSmokeWorkspace.delete_dtSearchIndex(WorkspaceElements::DtSearchName)
			expect(@automationSmokeTest.getdtSearchName(WorkspaceElements::DtSearchName).exists?).to be false
		end
	end

	context "Delete the Smoke Group" do
		it "would ensure there is no group called 'Smoke Group' in the environment" do
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
			@deleteSmokeWorkspace.delete_Group(CreateSmokeItems::GroupName)
			expect(@automationSmokeTest.getGroupNameElement(CreateSmokeItems::GroupName).exists?).to be false
		end
	end

	context "Delete the Smoke User" do
		it "would ensure there is no user called 'Smoke User' in the environment" do
			@deleteSmokeWorkspace.delete_User(CreateSmokeItems::FullName)
			expect(@automationSmokeTest.getUserNameElement(CreateSmokeItems::FullName).exists?).to be false
		end
	end

	context "Delete the Smoke Workspace" do
		it "would ensure there is no workspace called 'Smoke Workspace' in the environment" do
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
			@deleteSmokeWorkspace.delete_Workspaces
			expect(@automationSmokeTest.getWorkspaceNameElement(RelativityWorkspaceItems::WorkspaceNameSmoke).exists?).to be false
		end
	end

	context "Remove servers from Resourcepool" do
		it "would remove Agent, Worker, Analytics and Worker Manager Servers from the Resourcepool" do
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::Agents)
			@deleteSmokeWorkspace.remove_resourcepool(ServerTypes::Agent_Name, ServerTypes::Agent_Worker)
			@deleteSmokeWorkspace.remove_resourcepool(ServerTypes::Worker_Name, ServerTypes::Agent_Worker)
			@deleteSmokeWorkspace.remove_resourcepool(AddAnalyticsServer::Name, ServerTypes::Analytics)
			@deleteSmokeWorkspace.remove_resourcepool_WMS(AddWMS::Name, ServerTypes::WMS)
			expect(@automationSmokeTest.getServerName(ServerTypes::Agent_Name).exists?).to be false
			expect(@automationSmokeTest.getServerName(ServerTypes::Worker_Name).exists?).to be false
			expect(@automationSmokeTest.getServerName(AddAnalyticsServer::Name).exists?).to be false
			expect(@automationSmokeTest.getServerName(AddWMS::Name).exists?).to be false
		end
	end

end