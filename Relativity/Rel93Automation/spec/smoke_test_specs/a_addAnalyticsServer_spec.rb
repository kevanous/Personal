require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Adding Analytics server to a new Relativity Environment" do

	before {
		@login_N_CreateNewWorkspace = Login_N_CreateNewWorkspace.new
		@relativityworkspace = RelativityWorkspace.new
	}
	context "When an Analytics server is added to the Relativity Environment" do
    before {
      $url = RelativityUrl.const_get($env)
      $browser.goto $url
      @login_N_CreateNewWorkspace.relativityLogin(CreateSmokeItems::Email, CreateSmokeItems::Password)
      @relativityworkspace.AddAnalyticsServer(AddAnalyticsServer::Name)
			@relativityworkspace.AddServerToDefaultResourcePool(ServerTypes::Analytics, AddAnalyticsServer::Name)
    }

		it "Analyitics server should be in the server list in that Relativity environment" do
			expect($browser.iframe(:id =>'ListTemplateFrame').table(:id =>'ctl00_viewRenderer_itemList_listTable').text).to include(AddAnalyticsServer::Name).and include(AddAnalyticsServer::Status)
 		end
	end

end
