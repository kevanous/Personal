
require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'json'
require_relative 'InputData'

class RelativityWorkspace
  include Consilio
  include TestFramework
  include RelativityWorkspaceItems
  include ApplicationNames
  include GroupAccessNames
  include WorkspaceElements
  include CreateSmokeItems
  include CodingResponsive
  include AnalyticsIndexField
  include STR
  # include AddAnalyticsServer
  include AddWMS

  def iframe_main
    return $browser.iframe(:id=>"ListTemplateFrame")
  end

  def tab_iFrame
    return $browser.iframe(:id => "_externalPage")
  end

  def iframe_layout
    return $browser.iframe(:id=>"LB")
  end

  def iframe_folder
    return $browser.iframe(:id=>"FolderFrame")
  end

  def iframe_paneCollection
    # for this method to work, the iframe panecollection has to be inside of iframe folder
    return iframe_folder.iframe(:id=>"_paneCollection_ctl01_folderiFrame")
  end

  def column_resize_wait
    return iframe_main.div(:id=>"_main").a(:id=>'ctl00_ctl00_itemList_ResetColumnSizesButton').wait_until_present
  end

  def relativityMainPage
    $browser.table(:id=>"Table1").input(:title=>"Home").click
  end

  def NavigateToWorkspace(workspaceName)
    search_funnel_show = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Show Filters")
    search_funnel_hide = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Hide Filters")
    begin
      if search_funnel_show.exists?
        search_funnel_show.click
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(workspaceName)
        $browser.send_keys(:return)
        iframe_main.a(:text=> workspaceName).click
      elsif search_funnel_hide.exists?
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(workspaceName)
        $browser.send_keys(:return)
        iframe_main.a(:text=>workspaceName).click
      else
        raise "Search Text box funnel icon doesnt exist"
      end
    end
  end

  def DocsAreLoaded
    return $browser.iframe(:id=> "ListTemplateFrame").table(:id => "ctl00_ctl00_itemList_listTable")
  end

  def RelativityGroupAccess(groupName)
    $browser.input(:id=> "GetNavigateHomeScript").click
    if $browser.a(:class=>"dropdownParent ng-binding", :text=>groupName).visible?
      grouptab = $browser.a(:class=>"dropdownParent ng-binding", :text=>groupName)
    else
      grouptab = $browser.a(:text=>groupName)
    end
    grouptab.click
  end

  def TabAccess(tabName)
    if $browser.div(:id=>"horizontal-tabstrip").a(:class=>"dropdownParent ng-binding", :text =>tabName).exists? == true
      relativity_tab =  $browser.div(:id=>"horizontal-tabstrip").a(:class=>"dropdownParent ng-binding", :text =>tabName)
      relativity_tab_2 = $browser.div(:id=>"horizontal-tabstrip").a(:text =>tabName)
      if relativity_tab.visible? == true
        relativity_tab.click
      elsif relativity_tab_2.visible? == true
        relativity_tab_2.click
      else
        $browser.div(:id => 'transparentdimmerdiv').wait_while_present
        dropdown_tab = $browser.ElementByCss('#moreTabsButtonToggle')
        dropdown_tab.click
        relativity_tab = $browser.ElementByCss('#vertical-tabstrip > accordion > div > ul > li:contains(%s) > div > div.panel-heading > h4 > a > a.accordionParent.ng-scope.accordionParentVisible > span' %tabName)
        sleep (1)
        relativity_tab.click
      end
    end
  end

  def SelectSearchName(name)
    iframe_main.div(:id=>'_main').a(:id=>'ctl00_viewRenderer_itemList_ResetColumnSizesButton').wait_until_present
    search_funnel_show = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Show Filters")
    search_funnel_hide = iframe_main.a(:id=>"ctl00_viewRenderer_itemList_FilterSwitch", :title=>"Hide Filters")
    begin
      if search_funnel_show.exists?
        search_funnel_show.click
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(name)
        $browser.send_keys(:return)
        iframe_main.a(:text=> name).click
      elsif search_funnel_hide.exists?
        iframe_main.text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(name)
        $browser.send_keys(:return)
        iframe_main.a(:text=>name).click
      else
        raise "Search Text box funnel icon doesnt exist"
      end
    end
  end

  def SelectSearchName93(name, searchField)
    iframe_main.div(:id=>'_main').a(:id=>'ctl00_ctl00_itemList_ResetColumnSizesButton').wait_until_present
    search_funnel_show = iframe_main.a(:id=>"ctl00_ctl00_itemList_FilterSwitch", :title=>"Show Filters")
    search_funnel_hide = iframe_main.a(:id=>"ctl00_ctl00_itemList_FilterSwitch", :title=>"Hide Filters")
    begin
      if search_funnel_show.exists?
        search_funnel_show.click
        iframe_main.text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[#{searchField}]-T").set(name)
        $browser.send_keys(:return)
        iframe_main.a(:text=> name).wait_until_present.click
      elsif search_funnel_hide.exists?
        iframe_main.text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[#{searchField}]-T").set(name)
        $browser.send_keys(:return)
        iframe_main.a(:text=>name).click
      else
        raise "Search Text box funnel icon doesnt exist"
      end
    end
  end

  def SearchResult(searchterm, searchField)
    iframe_main.div(:id=>'_main').a(:id=>'ctl00_ctl00_itemList_ResetColumnSizesButton').wait_until_present
    search_funnel_show = iframe_main.a(:id=>"ctl00_ctl00_itemList_FilterSwitch", :title=>"Show Filters")
    search_funnel_hide = iframe_main.a(:id=>"ctl00_ctl00_itemList_FilterSwitch", :title=>"Hide Filters")
    begin
      if search_funnel_show.exists?
        search_funnel_show.click
        iframe_main.text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[#{searchField}]-T").set(searchterm)
        $browser.send_keys(:return)
      elsif search_funnel_hide.exists?
        iframe_main.text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[#{searchField}]-T").set(searchterm)
        $browser.send_keys(:return)
      else
        raise "Search Text box funnel icon doesnt exist"
      end
    end
  end

  def CustodianUpdateAgent
    $browser.ElementByCss('#_viewTemplate_edit1_anchor').click
    $browser.ElementByCss('#_editTemplate__kCuraScrollingDiv__enabled__radioButtonList_radioButtonList_1').click
    sleep (2)
    $browser.ElementByCss('#_editTemplate_save1_button').click
    $browser.ElementByCss('#_viewTemplate_edit1_anchor').click
    $browser.ElementByCss('#_editTemplate__kCuraScrollingDiv__enabled__radioButtonList_radioButtonList_0').click
    sleep(2)
    $browser.ElementByCss('#_editTemplate_save1_button').click
    $browser.div(:id=>"_main").div(:class=>"artifactActionBar").a(:text=>"Edit").wait_until_present
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li.relativity-subtab.ng-scope.active > a').click
  end

  def RDOUpdateFinished(timeout=30)
    begin
      Watir::Wait.until(timeout, message) {
      $browser.RefreshPage
      iframe_main.tr(:id=>'ctl00_viewRenderer_itemList_ctl00_viewRenderer_itemList_ROW0').tds[7].text.include? "Completed" }
    rescue
      return false
      puts "RDO Update did not run successfully"
    end
    return true
  end

  def docs_load_wait_firstTime
    iframe_main.table(:id => "ctl00_ctl00_itemList_listTable").wait_until_present(80)
  end

  def docs_load_wait_secondTime
    sleep (5)
    begin
      i = 1
      while i > 5 && $browser.div(:id => 'querywindowcontent').visible? == true do
        sleep(5)
        i = i+1
      end
    end
  end

  def smokeWorkspaceAccess(workspaceName)
    workspaceName = iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").a(:text=>workspaceName)
    if workspaceName.exists? == true
      workspaceName.click
      iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present(20)
    end
  end

  def AnalyticsIndexField(fieldName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Search Indexes").click
    iframe_main.a(:text=>"New Analytics Index").click
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__indexName_textBox_textBox").set fieldName
    $browser.select_list(:id=>'_editTemplate__kCuraScrollingDiv__analyticsProfileDropDown_dropDownList').select "Default"
    $browser.select_list(:id=>'_editTemplate__kCuraScrollingDiv__analyticsServerURLDropDown_dropDownList').option(:index=> 1).select
    $browser.radio(:id=>'_editTemplate__kCuraScrollingDiv__optimizeTrainingSet__radioButtonList_radioButtonList_1').set
    $browser.ElementByCss('#_editTemplate_save1_button').click
    $browser.ElementByCss('#_viewTemplate__kCuraScrollingDiv__fullPopulationButton_button').click
    $browser.window(:index => 1).wait_until_present
      $browser.window(:index => 1).use do
      $browser.div(:id=>'_main').div(:id=>'_bottomActionBarContainer').div(:class=>'artifactPopupActionBarFull GluedToBottom').a(:id=>'_ok_button').click
    end
    $browser.div(:id=>'_main').div(:class=>'cardSection').div(:class=>'editSectionTitle').wait_until_present
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li.relativity-subtab.ng-scope.active > a').click
    sleep 3
    $browser.iframe(:id=>'ListTemplateFrame').div(:id=>'ctl00_viewRenderer_itemList_tableDiv').a(:text=>'Smoke Analytics').click
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Search Indexes").click
  end

  def STRFieldentry(fieldName)
    iframe_main.a(:text=>"New Search Terms Report").click
    $browser.text_field(:name=>"_dynamicTemplate$_dynamicViewFieldRenderer$ctl02$textBox$textBox").set(fieldName)
    $browser.input(:id =>'_dynamicTemplate__dynamicViewFieldRenderer_ctl03_pick').click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      sleep 2
      $browser.radio(:id=>'radio_0').set
      $browser.a(:id =>'_oneListPicker_ctl03_button').click
    end
    $browser.input(:id =>"_dynamicTemplate__dynamicViewFieldRenderer_ctl04_pick").click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.radio(:id=>'radio_2').set
      $browser.a(:id =>'_oneListPicker_ctl03_button').click
    end
    $browser.radio(:id=>'_dynamicTemplate__dynamicViewFieldRenderer_ctl05_radioButtonListField_radioButtonList_0').set
    $browser.a(:id =>'_dynamicTemplate_ctl04_button').click
    $browser.a(:id =>'_dynamicTemplate__kCuraScrollingDiv__dynamicViewFieldRenderer_ctl11_anchor').click
    $browser.iframe(:id=>'_externalPage').div(:class=>'css-tbl cardSection').div(:class =>'cardRelativityControl newTermsSTR').textarea(:id =>'txtNewTerms').set ("test \nsmoke")
    sleep 2
    $browser.iframe(:id=>'_externalPage').div(:class=>'css-tbl cardSection').div(:class =>'cardRelativityControl newTermsSTR').a(:id=>'cmdAddTerms_button').click
    $browser.iframe(:id=>'_externalPage').div(:class=>'css-tbl cardSection').div(:id=>'_results__kCuraScrollingDiv').input(:id=>'checkbox_0').click
    $browser.iframe(:id=>'_externalPage').div(:class=>'css-tbl cardSection').div(:id=>'_results__kCuraScrollingDiv').input(:id=>'checkbox_1').click
    $browser.iframe(:id=>'_externalPage').div(:class=>'css-tbl cardSection').div(:class=>'modify-terms-preview-container').a(:id=>'cmdApplyColor_button').click
    sleep 2
    $browser.iframe(:id=>'_externalPage').div(:class=>'ui-dialog ui-widget ui-widget-content ui-corner-all cornerclosebutton').span(:class=>'ui-button-text').click
    $browser.iframe(:id=>'_externalPage').div(:class=>'genericArtifactTopActionBar').a(:class=>'ActionButton').click
    sleep 2
    $browser.ElementByCss('#_dynamicTemplate__kCuraScrollingDiv__dynamicViewFieldRenderer_ctl12_button').click
    sleep 2
    $browser.div(:class=>'ui-dialog ui-widget ui-widget-content ui-corner-all cornerclosebutton').span(:class=>'ui-button-text').click
    sleep 5
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li.relativity-subtab.ng-scope.active > a').click
  end

  def DeleteSTR
    sleep 2
    $browser.iframe(:id =>'ListTemplateFrame').div(:id=>'_main').tr(:id =>'ctl00_ctl00_itemList_topActionRow').a(:id =>'ctl00_ctl00_itemList_FilterSwitch').click
    $browser.iframe(:id =>'ListTemplateFrame').text_field(:id=>"ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(STR::Name)
    $browser.send_keys(:return)
    sleep 2
    $browser.iframe(:id =>'ListTemplateFrame').div(:id =>'_main').tr(:class =>'itemListRowAlt').input(:id =>'checkbox_0').click
    $browser.iframe(:id=>'ListTemplateFrame').select_list(:name=>"ctl00$checkedItemsAction").option(:index=> 0).select
    $browser.iframe(:id=>'ListTemplateFrame').select_list(:name=>"ctl00$checkedItemsActionToTake").option(:index=> 1).select
    $browser.iframe(:id=>'ListTemplateFrame').a(:id=>'ctl00_ctl04_button').click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.ElementByCss("#_ok_button").click
    end
  end

  def DeleteAnalytics
    $browser.iframe(:id =>'ListTemplateFrame').tr(:id=>'ctl00_viewRenderer_itemList_topActionRow').div(:class=>'actionCellContainer rightAligned').a(:id=>'ctl00_viewRenderer_itemList_FilterSwitch').click
    $browser.iframe(:id =>'ListTemplateFrame').text_field(:id=>"ctl00_viewRenderer_itemList_FILTER-BOOLEANSEARCH[Name]-T").set(AnalyticsIndexField::Name)
    $browser.send_keys(:return)
    $browser.iframe(:id =>'ListTemplateFrame').div(:id =>'_main').tr(:class =>'itemListRowAlt').input(:id =>'checkbox_0').click
    $browser.iframe(:id =>'ListTemplateFrame').div(:id =>'_main').div(:id =>'ctl00_BottomActionBar').select(:id =>'ctl00_ctl18').option(:value=>'Delete').click
    $browser.iframe(:id =>'ListTemplateFrame').div(:id =>'_main').div(:id =>'ctl00_BottomActionBar').a(:id=>'ctl00_go_button').click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.ElementByCss("#_ok_button").click
    end
  end

  def createNewChoices(choiceName)
    $browser.a(:text=>"Choices").wait_until_present.click
    $browser.iframe_main.a(:text =>"New Choice").wait_until_present.click
    $browser.select_list(:id=>"_editTemplate__objectType_dropDownList").select "Smoke Designation (Document)"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set choiceName
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "10"
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__ctrl_Checkbox").click
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__alt_Checkbox").click
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__shift_Checkbox").click
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
  end

  def get_WorkspaceAdmin_tab(workspaceAdmin_tab)
   $browser.div(:id=>"horizontal-subtabstrip").a(:text=>workspaceAdmin_tab).wait_until_present.click
    sleep 3
    if $browser.alert.exists?
      $browser.alert.ok
    end
  end

  def AddWMS(fieldName)
    byebug
    #Click on Server and Agent Management
    RelativityGroupAccess("Server & Agent Management")
    # Click on Servers
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
    # $browser.ElementByCss("#horizontal-tabstrip > ul > li:nth-child(5) > a.dropdownParent.ng-binding").click
    # $browser.ElementByCss("#horizontal-subtabstrip > ul > li:nth-child(4) > a").click
    # $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
    iframe_main.a(:text=>"New Resource Server").click
    $browser.text_field(:id =>'_editTemplate__kCuraScrollingDiv_Name_textBox_textBox').set fieldName
    $browser.select_list(:id=>'_editTemplate__kCuraScrollingDiv_Type_dropDownList').select "Worker Manager Server"
    $browser.text_field(:name =>'_editTemplate$_kCuraScrollingDiv$ProcessingServerUrl$textBox$textBox').set(AddWMS::URL)
    $browser.div(:id=>'_main').a(:id =>'_editTemplate_save1_button').click
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
    sleep 3
    if $browser.alert.exists?
      $browser.alert.ok
    end
    sleep 5
  end

  def AddAnalyticsServer(fieldName)
    byebug
    $browser.ElementByCss("#horizontal-tabstrip > ul > li:nth-child(5) > a.dropdownParent.ng-binding").click
    $browser.ElementByCss("#horizontal-subtabstrip > ul > li:nth-child(4) > a").click
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
    iframe_main.a(:text=>"New Resource Server").click
    $browser.text_field(:id =>'_editTemplate__kCuraScrollingDiv_Name_textBox_textBox').set fieldName
    $browser.select_list(:id=>'_editTemplate__kCuraScrollingDiv_Type_dropDownList').select "Analytics Server"
    $browser.ElementByCss('#_editTemplate__kCuraScrollingDiv_AnalyticsServerType_checkBox_ctl00_0').click
    $browser.ElementByCss('#_editTemplate__kCuraScrollingDiv_AnalyticsServerType_checkBox_ctl00_1').click
    $browser.text_field(:name =>'_editTemplate$_kCuraScrollingDiv$ProcessingServerUrl$textBox$textBox').set(AddAnalyticsServer::URL)
    $browser.text_field(:name=>'_editTemplate$_kCuraScrollingDiv$RestPort$int32TextBox$textBox').set(AddAnalyticsServer::RestAPIPort)
    $browser.text_field(:name=>'_editTemplate$_kCuraScrollingDiv$RestUser$textBox$textBox').set(AddAnalyticsServer::RestUsername)
    $browser.text_field(:name=>'_editTemplate$_kCuraScrollingDiv$RestPass$_passwordTextBox$_password_TextBox').set(AddAnalyticsServer::RestPass)
    $browser.div(:id=>'_main').a(:id =>'_editTemplate_save1_button').click
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
    sleep 3
     if $browser.alert.exists?
      $browser.alert.ok
    end
    sleep 5
  end

  def AddServerToDefaultResourcePool(serverType, serverName)
    RelativityGroupAccess("Server & Agent Management")
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Resource Pools").click
    iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").a(:text=>"Default").click
    if $browser.td(:text=>serverName).exists? == false
      $browser.span(:text=>serverType).parent.spans[2].a(:text=>"Add").wait_until_present.click
      $browser.window(:index => 1).wait_until_present
      $browser.window(:index => 1).use do
        $browser.td(:text=>serverName).parent.tds[0].input.click
        $browser.ElementByCss('#_ok2_button').click
      end
    end
    sleep 3
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Servers").click
  end

  def getWorkspaceArtifactID
    RelativityGroupAccess("Workspaces")
    iframe_main.a(:title=>"Edit View").wait_until_present.click
    if $browser.select(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_ListOneBox").option(:text=>"Case Artifact ID").exists? == true
      $browser.select(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_ListOneBox").option(:text=>"Case Artifact ID").click
      $browser.a(:title=>"Move Right").click
    end
      $browser.a(:text=>"Save").click
      return iframe_main.td(:text=>RelativityWorkspaceItems::WorkspaceNameSmoke).parent.tds[4].text
    #on the above line, we are assuming that the artifact id will be on the fifth column.
  end

  def checkDocsloaded
    begin
      i = 1
      while i > 10 && iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs[0].exists? == false do
        sleep(15)
        $browser.refresh
        i = i+1
      end
    end
    return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

end