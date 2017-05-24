require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require_relative '../../lib/InputData'
require 'byebug'

describe "Adding Worker Manager server to a new Relativity Environment" do

	before :all do 
		@relativity = Login_N_CreateNewWorkspace.new
		@workspace = RelativityWorkspace.new
		$url = RelativityUrl.const_get('Automation_forms')
		$browser.goto $url
		@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
		@relativity.switch_ui("Switch to Classic UI")
		byebug		
	end

	context "When a Worker Manager server is added to Relativity Environment" do
		before {
			@workspace.AddWMS(AddWMS::Name)
			@workspace.AddServerToDefaultResourcePool(ServerTypes::WMS, AddWMS::Name)

			# adding agent and worker server to the default resource pool as well
			@workspace.AddServerToDefaultResourcePool(ServerTypes::Agent_Worker, ServerTypes::Agent_Name)
			@workspace.AddServerToDefaultResourcePool(ServerTypes::Agent_Worker, ServerTypes::Worker_Name)
		}	

		it "Worker Manager server should be in the server list in that Relativity Environment" do
			expect($browser.iframe(:id =>'ListTemplateFrame').table(:id =>'ctl00_ctl00_itemList_listTable').text).to include(AddWMS::Name).and include(AddWMS::Status)
 		end
	end
	
end
