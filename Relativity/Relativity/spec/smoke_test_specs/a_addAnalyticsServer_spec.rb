require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Adding Analytics server to a new Relativity Environment" do
	before :all do
		@relativity	= Login_N_CreateNewWorkspace.new
		@workspace 	= RelativityWorkspace.new

		$url = RelativityUrl.const_get('Automation_forms')
		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")
		# need to add application installation manager
		# need to add upgrade manager
		# need to add upgrade worker
		# go to Server and Agent Management
		# add click on New Agent .....
		@workspace.AddAnalyticsServer(AddAnalyticsServer::Name)
		@workspace.AddServerToDefaultResourcePool(ServerTypes::Analytics, AddAnalyticsServer::Name)
	end

	context "When an Analytics server is added to the Relativity Environment" do
		it "Analyitics server should be in the server list in that Relativity environment" do
			expect($browser.iframe(:id =>'ListTemplateFrame').table(:id =>'ctl00_ctl00_itemList_listTable').text).to include(AddAnalyticsServer::Name).and include(AddAnalyticsServer::Status)
			expect($browser.iframe(:id =>'_externalPage').table(:id =>'fil_itemListFUI').text).to include(AddAnalyticsServer::Name).and include(AddAnalyticsServer::Status)
 		end
	end
end
