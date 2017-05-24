require 'rubygems'
require 'bundler/setup'
require 'TestFramework'
require_relative 'RelativityWorkspace'
require 'byebug'

class Document < RelativityWorkspace
  include Consilio
	include TestFramework

  def DocumentViewFolder(foldername)
   	self.iframe_main.when_present.select_list(:id=>"ctl00_viewsDropDown").when_present.option(:text =>foldername).select
  end

  def BulkAction(action)
    self.iframe_main.select_list(:name=>"ctl00$checkedItemsAction").select "Checked"
    self.iframe_main.select_list(:name=>"ctl00$checkedItemsActionToTake").select action
    self.iframe_main.a(:text => "Go").click
  end

  def BulkEdit()
  	self.iframe_main.select_list(:name=>"ctl00$checkedItemsAction").select "Checked"
  	self.iframe_main.select_list(:name=>"ctl00$checkedItemsActionToTake").select"Edit"
  	self.iframe_main.a(:text => "Go").click
	end

	def SelectDocumentFirst
		$browser.iframe(:id=>'ListTemplateFrame').checkbox(:id=>'checkbox_0').click #selecting the first document in the workspace folder All Document 
	end

	def OpenBulkDialog(selection, action) #checked, all or these
		$browser.ElementByCss("#ctl00_checkedItemsAction").SelectByText(selection) #selection like all or checked or these 1000
		$browser.ElementByCss("ctl00_checkedItemsActionToTake").SelectByText(action) #action like either edit, or move or delete
		$browser.ElementByCss("#ctl00_ctl04_button").click
	end

	def SetBulkEditCustId(value)
		$browser.ElementByCss("#dialogId").wait_until_present
		$browser.ElementByCss("#LayoutDropdownList").SelectByText("Document Metadata")
		$browser.ElementByCss("#dynamicViewRenderer_ctl01_pick").when_present.click
		$browser.ElementByCss("#_oneListPicker_ctl00_itemList_listTable > tbody > tr:eq(%s) > td:eq(1) > input"%value).click
		$browser.ElementByCss("#_oneListPicker_ctl03_button").click #set the custid
	end

	def GetDocumentById(documentId)
		$browser.GetCssInFrame("ListTemplateFrame", "#ctl00_ctl00_itemList_listTable > tbody > tr > td:nth-child(6):contains(%s)"%documentId)
		#using the td, get the parent tr and transform into json object
	end

	def GetDocumentByIndex(index)
		return $browser.GetCssInFrame("ListTemplateFrame", "#ctl00_ctl00_itemList_listTable > tbody > tr:eq(%s)"%index)
	end

	def DocumentRowToObject(row)
		values = Hash.new
		values["DocumentID"] = $browser.ByChildCss(row, "td:eq(6)").text
		values["CustID"] = $browser.ByChildCss(row, "td:eq(10)").text
		return values
	end

	def GetGroupIdentifierID(rowindex)
    return self.iframe_main.tr(:id => "ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW#{rowindex}").tds[7].text
  end

  def codeDocResponsive(layoutName, code)
  	iframe_document = $browser.iframe(:id=>"_documentViewer__viewerFrame")
  	iframe_document.div(:id=>"page.1").wait_until_present(25)
  	iframe_docProfile = $browser.iframe(:id=>"_profileAndPaneCollectionFrame").iframe(:id=>"_documentProfileFrame")
  	iframe_docProfile.select_list(:id=>"_documentProfileEditor_layoutDropdown").select layoutName
  	iframe_docProfile.a(:id=> "_documentProfileEditor_edit1_button").click
  	sleep 4
    iframe_docProfile.td(:class=>"editFieldValueProfile").select_list.select code
    iframe_docProfile.a(:text=>"Save and Back").click
		iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present(10)
  end

  def createSummaryReport(reportName)
  	$browser.span(:class=>"quickNavIcon").click
  	$browser.text_field(:id=>"ctl30_ctl30_ctl03").set "Summary"
  	$browser.a(:title=>"Summary Reports").wait_until_present.click
  	iframe_main.a(:text=>"New Summary Report").wait_until_present(500).click
  	$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").wait_until_present.set reportName
  	$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__reportOnSubfolders_booleanDropDownList__dropDownList").select "Yes"
  	$browser.a(:text=>"Add Columns").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.a(:id=>"_reportFields_itemList_FilterSwitch").click
    	$browser.text_field(:id=>"_reportFields_itemList_FILTER-WC[DisplayName]").set "Smoke Designation"
    	$browser.send_keys(:return)
    	table_contents = $browser.table(:id=>"_reportFields_itemList_listTable")
    	table_contents.wait_until_present
    	table_contents.td(:text=>"Smoke Designation: (not set)").parent.checkbox.click
    	table_contents.td(:text=>"Smoke Designation: Smoke Responsive").parent.checkbox.click
    	$browser.a(:id=>"_save_button").click
    	sleep 3
    end
    $browser.a(:id=>"_editTemplate_save1_button").click
  end

  def summaryReportCount
  	$browser.table(:id=>"_viewTemplate__kCuraScrollingDiv__report_itemList_listTable").wait_until_present
  	table_result = $browser.table(:id=>"_viewTemplate__kCuraScrollingDiv__report_itemList_listTable").hashes
  	return table_result[0]["Smoke Designation: Smoke Responsive"]
  end

  def dtSearchIndexCreate(dtSearchName, savedSearchName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' %"Search Indexes").click
    iframe_main.a(:text=>"New dtSearch Index").wait_until_present.click
    $browser.text_field(:id=>"_EditTemplate__kCuraScrollingDiv__indexName_textBox_textBox").set dtSearchName
    $browser.select_list(:id=>"_EditTemplate__kCuraScrollingDiv__searchableSavedSearchDropDown_dropDownList").select savedSearchName
    $browser.text_field(:id=>"_EditTemplate__kCuraScrollingDiv__EmailId_textBox_textBox").set "kshrestha@consilio.com"
    $browser.a(:text => "Save").click
    $browser.a(:text => "Build Index: Full").wait_until_present.click
    $browser.span(:text=> "Yes").wait_until_present.click
  end

  def dtSearchIndexSuccess
    $browser.div(:id=>"ProgressStatusSection").img(:alt =>"Success").wait_until_present(120)
    return $browser.div(:id=>"statusMessage").text
  end

  def dtSearchIndexNewVerify(dtSearchName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' %"Search Indexes").click
    return iframe_main.a(:text=>dtSearchName).exists?
  end
  
end