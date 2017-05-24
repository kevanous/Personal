require_relative '../spec_helper'
require_relative '../../lib/InputData'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/ProcessTranscript'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'open-uri'
require 'byebug'

describe "Validating the Relativity Smoke Workspace and Transcript Processing" do
  before {
    @ProcessTranscript  = ProcessTranscript.new
    @workspace          = RelativityWorkspace.new
    @relativity         = Login_N_CreateNewWorkspace.new

    @url = RelativityUrl.const_get('Automation_forms')
    $browser.goto @url
    @relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
    @relativity.switch_ui("Switch to Classic UI")	
  }

	context 'To Process Transcript user should need to run a Mass Operation to control the Transcript View' do
  	it "select Smoke workspace, navigate to Documents Tab and validate total count of documents should be > 0" do
      @workspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
      @workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @workspace.TabAccess(ApplicationNames::Documents)
      expect(@ProcessTranscript.ValidateDocumentsCount).to be > 0
    end

    it "Search for a transcript and run a mass operation to process it" do
			@workspace.SelectSearchName93(SearchField::DocumentNumber, SearchField::ControlNumber)
      @ProcessTranscript.RunTranscriptProcess(TranscriptAddHeaderFooter::HeaderText, TranscriptAddHeaderFooter::FooterText)
      expect(@ProcessTranscript.ValidateProcessedtransacript(
      SearchField::DocumentNumber,
      TranscriptAddHeaderFooter::HeaderText,
      TranscriptAddHeaderFooter::FooterText,
      WordIndex::Search_Word1
      )).to be true
    end
 	end
end
