require_relative '../spec_helper'
require_relative '../../lib/RelativityWorkspace'
require_relative '../../lib/InputData'
require_relative '../../lib/AutomationSmokeTest'
require_relative '../../lib/Document'
require_relative '../../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Coding documents as Responsive, also creating a summary report, view, search, imaging profile and dtSearch index " do
		before {
			@relativity	= Login_N_CreateNewWorkspace.new
			@workspace 	= RelativityWorkspace.new
			@autoTest 	= AutomationSmokeTest.new
			@document 	= Document.new

			$url = RelativityUrl.const_get('Automation_forms')
			$browser.goto $url
			@relativity.relativityLogin(AdminLogin::Id, AdminLogin::Pwd)
			@relativity.switch_ui("Switch to Classic UI")	
		}

	context "Code a document as responsive" do
		it "we are setting one document as smoke responsive using smoke layout" do
			@workspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@workspace.SelectSearchName93(CodingResponsive::DocumentControlNumber, SearchField::ControlNumber)
			@document.codeDocResponsive(WorkspaceElements::LayoutName, WorkspaceElements::ChoiceName1)
		end
	end

	context "Create a new summary report" do
		it "a new summary should be created and the summary report should have a count of 1" do
			@document.createSummaryReport(CodingResponsive::ReportName)
			expect(@document.summaryReportCount).to eq("1")
		end
	end

	context "Create a new view to return responsive documents" do
		it "should create a new view Smoke Responsive Document" do
			@workspace.TabAccess(ApplicationNames::WorkspaceAdmin)
			@autoTest.createNewView(WorkspaceElements::ViewName, WorkspaceElements::FieldName, WorkspaceElements::Operator, WorkspaceElements::ChoiceName1)
		end
	end

	context "Create a new search and imaging profile" do
		it "a new search profile should be created" do
			@workspace.TabAccess(ApplicationNames::Documents)
			@autoTest.createSearchProfile(WorkspaceElements::SavedSearchName, WorkspaceElements::FolderName)
			expect(@autoTest.savedSearchResultCount).to be > 1
		end
	end

	context "Create a new dtSearch index" do
		it "will create a new dtSearch index" do
			@workspace.TabAccess(ApplicationNames::WorkspaceAdmin)
			@document.dtSearchIndexCreate(WorkspaceElements::DtSearchName, WorkspaceElements::SavedSearchName)
			expect(@document.dtSearchIndexSuccess).to eq ("Active - Indexed")
			expect(@document.dtSearchIndexNewVerify(WorkspaceElements::DtSearchName)).to be true
		end
	end

	context "View responsive documents" do
		it "should have 1 document for responsive and 4 documents for responsive with family" do
			@workspace.TabAccess(ApplicationNames::Documents)
			@autoTest.viewResponsiveDocs(WorkspaceElements::ViewName)
			expect(@autoTest.verifyResponsiveDocuments).to eq(1)
			expect(@autoTest.verifyResponsiveDocumentsInclFamily).to eq(4)
		end
	end

end
