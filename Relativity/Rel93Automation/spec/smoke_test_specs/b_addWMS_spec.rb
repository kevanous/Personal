require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/Login_N_CreateNewWorkspace'

require_relative '../../lib/InputData'
require 'byebug'

describe "Adding Worker Manager server to a new Relativity Environment" do

	before {
		@login_N_CreateNewWorkspace = Login_N_CreateNewWorkspace.new
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}
	
	context "When a Worker Manager server is added to Relativity Environment" do
    before {
      $url = RelativityUrl.const_get($env)
      $browser.goto $url
      @login_N_CreateNewWorkspace.relativityLogin(CreateSmokeItems::Email, CreateSmokeItems::Password)
			@relativityworkspace.AddWMS(AddWMS::Name)
			@relativityworkspace.AddServerToDefaultResourcePool(ServerTypes::WMS, AddWMS::Name)
			
			#adding agent and worker server to the default resource pool as well
			@relativityworkspace.AddServerToDefaultResourcePool(ServerTypes::Agent_Worker, ServerTypes::Agent_Name)
   		@relativityworkspace.AddServerToDefaultResourcePool(ServerTypes::Agent_Worker, ServerTypes::Worker_Name)
  	}

		it "Worker Manager server should be in the server list in that Relativity Environment" do
			expect($browser.iframe(:id =>'ListTemplateFrame').table(:id =>'ctl00_viewRenderer_itemList_listTable').text).to include(AddWMS::Name).and include(AddWMS::Status)
 		end
	
	end

end
