require_relative '../spec_helper'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Create a new workspace, create a new parent document ID field and add the smoke group to the newly created smoke workspace" do
  
  before :all do
      @relativity = Login_N_CreateNewWorkspace.new
      @workspace  = RelativityWorkspace.new
      @autoTest   = AutomationSmokeTest.new
      @url        = RelativityUrl.const_get('Automation_forms')
      $browser.goto @url
      @relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
      @relativity.switch_ui("Switch to Classic UI")
  end

  context 'To Create new Smoke Workspace user should need to be login as a Somke User' do
    before{}    

    it "should allow the Smoke user to create a new WorkSpace" do
      @workspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
      @relativity.createNewWorkspace(RelativityWorkspaceItems::WorkspaceNameSmoke, CreateSmokeItems::Client, CreateSmokeItems::Matter)
      expect(@relativity.newWorkspaceCreated(RelativityWorkspaceItems::WorkspaceNameSmoke)).to be true
    end
  end

  context "Creating the parent document ID field" do
    before{}

    it "creates a new field called Parent Document ID" do
      @workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @workspace.TabAccess('Workspace Admin')
      @autoTest.createNewField(ParentDocIDField::ParentIDName, ParentDocIDField::ParentFieldType)
      @workspace.get_WorkspaceAdmin_tab(WorkspaceAdminTabs::Fields)
      expect(@relativity.getfieldName(ParentDocIDField::ParentIDName, SearchField::Name)).to eq (ParentDocIDField::ParentIDName)
    end
  end

  context "Adding the Smoke Group" do
    before{}

    it "adds the smoke group to the smoke workspace and previews shows that only Documents tab displays" do
      @relativity.addSmokeGroup(WorkspaceAdminTabs::WorkspaceDetails, CreateSmokeItems::GroupName)
      expect(@relativity.previewNoticationExists).to be true
      expect(@relativity.firstTabName).to eq("Documents")
      expect(@relativity.otherTabsExists).to be false
      expect(@relativity.returnsToWorkspaceDetails).to be true
    end
  end
end
