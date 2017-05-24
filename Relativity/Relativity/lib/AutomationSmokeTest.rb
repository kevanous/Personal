require 'rubygems'
require 'bundler/setup'
require 'byebug'
require_relative 'RelativityWorkspace'
require_relative 'InputData'

class AutomationSmokeTest < RelativityWorkspace

	# Method Added for Rel 94 Testing - Working
	def setInWindow(element)
		$browser.window(:index => 1).wait_until_present
		$browser.window(:index => 1).use do
				$browser.td(:text=>element).wait_until_present
				$browser.td(:text=>element).parent.radio.set
				$browser.a(:id=>"_ok2_button").click
			end
		$browser.window(:index => 1).wait_while_present
	end

  # Method to Filter the first field with text provided
  def filterName(name)
    $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').text_field(:id => 'ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[Name]-T').wait_until_present.set name
    $browser.send_keys :enter    		
  end

  def filterFullName(name)
    $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').text_field(:id => 'ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[FullName]-T').wait_until_present.set name
    $browser.send_keys :enter    		
  end

  def createSmokeClient(clientName)
  	# $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % 'Clients', 3).wait_until_present.click    
    self.filterName(clientName)
		if $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').a(:text => clientName).exists? == true
			puts 'Client Already Exists'
			return true
		else
			puts 'Creating new Client:' + clientName
			self.iframe_main.div(:id=>"_main").a(:title=>"New Client").click
			$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set clientName
			$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__number_textBox_textBox").set Time.now.to_i
			$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__status_dropDownList").select "Active"
			$browser.a(:id=> "_editTemplate_save1_button").wait_until_present
	    $browser.a(:id=> "_editTemplate_save1_button").click
			return $browser.tr(:id=>"_name").td(:text => clientName).exists?
		end
  end

  def createSmokeMatter(matterName)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Matters").wait_until_present.click    
    self.filterName(matterName)
		if $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').a(:text => matterName).exists? == true
				puts 'Matter Already Exists'
				return true
		else
				puts 'Creating new Matter:' + matterName
				self.iframe_main.div(:id=>"_main").a(:title=>"New Matter").click
				$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set matterName
				$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__number_textBox_textBox").set Time.now.to_i
				$browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__status_dropDownList").select "Active"
				ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).click
				self.setInWindow(CreateSmokeItems::Client)
				$browser.a(:id=> "_editTemplate_save1_button").wait_until_present.click
				return $browser.tr(:id => "_name").td(:text => matterName).exists?
		end
  end

  def createSmokeUser(firstName, lastName, email, newpassword, fullname)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users").wait_until_present.click
    self.filterFullName(fullname)    
	  if $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').a(:text => fullname).exists? == true
				puts 'User Already Exists'
				return true
	  else
				puts 'Creating new User:' + fullname
				self.iframe_main.div(:id=>"_main").a(:title=>"New User").click
				$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__firstName_textBox_textBox").set firstName
				$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__lastName_textBox_textBox").set lastName
				$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__emailAddress_textBox_textBox").set email
				ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).click
				self.setInWindow(CreateSmokeItems::Client)
				# $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__password_radioButtonListField_radioButtonList_2").wait_until_present.click
		    # $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__newPassword__passwordTextBox__password_TextBox").set newpassword
				# $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__retypePassword__passwordTextBox__password_TextBox").set newpassword
				$browser.a(:id=> "_editTemplate_save1_button").click
				$browser.alert.wait_until_present
		    if $browser.alert.exists?
		      $browser.alert.ok
					$browser.alert.wait_while_present
		    end
      return $browser.tr(:id => "_firstName").td(:text => firstName).exists?
	  end
  end

=begin  #This below method is to create internal users only
  def createIntUser(firstName, lastName, email, pwd)
		    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users", 3).click
		    self.iframe_main.div(:id=>"_main").a(:title=>"New User").click
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__firstName_textBox_textBox").set firstName
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__lastName_textBox_textBox").set lastName
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__emailAddress_textBox_textBox").set email
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__authenticationData_textBox_textBox").set CreateInternalUsers::AuthData
		    ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).click
				self.setInWindow(CreateInternalUsers::Client_Int)
		    $browser.input(:id=>"_editTemplate__kCuraScrollingDiv__password_radioButtonListField_radioButtonList_2").wait_until_present.click
		    sleep 2
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__newPassword__passwordTextBox__password_TextBox"). set pwd
		    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__retypePassword__passwordTextBox__password_TextBox"). set pwd
		    $browser.a(:id=> "_editTemplate_save1_button").click
		    sleep 1
		    if $browser.alert.exists?
		      $browser.alert.ok
		    end
		    sleep 1
  end
=end

  def createSmokeGroup(groupName)
		$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Groups").wait_until_present.click
    self.filterName(groupName)    
    if $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').a(:text => groupName).exists? == true
        puts 'Group Already Exists'
        return true
    else
        puts 'Creating New Group:' + groupName
        self.iframe_main.div(:id=>"_main").a(:title=>"New Group").wait_until_present.click
        $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set groupName
        ElementByCss('#_editTemplate__kCuraScrollingDiv__client_pick', 3).wait_until_present.click
        self.setInWindow(CreateSmokeItems::Client)
        $browser.a(:id=> "_editTemplate_save1_button").wait_until_present.click
        $browser.a(:id=> "_editTemplate_save1_button").wait_while_present
        return $browser.tr(:id => "_groupName").td(:text => groupName).exists?
    end
  end

  def addGroup(name)
        $browser.ElementByCss('#_viewTemplate__kCuraScrollingDiv__groups_itemList_ctl10_anchor').wait_until_present.click    
        $browser.window(:index => 1).wait_until_present
        $browser.window(:index => 1).use do
          $browser.text_field(:id => '_artifacts_itemList_FILTER-BOOLEANSEARCH[Name]-T').wait_until_present.set name
          $browser.send_keys :enter
          $browser.td(:text => name).parent.tds[0].wait_until_present.click         
          $browser.ElementByCss('#_ok2_button').click
        end
        $browser.window(:index => 1).wait_while_present
  end

	def addUserToGroup(fullUserName, groupName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users").wait_until_present.click
    $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').text_field(:id => 'ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[FullName]-T').wait_until_present        
    $browser.iframe(:id => 'ListTemplateFrame').table(:class => 'itemListTable').text_field(:id => 'ctl00_ctl00_itemList_FILTER-BOOLEANSEARCH[FullName]-T').set fullUserName
    $browser.send_keys :enter
    $browser.iframe(:id => "ListTemplateFrame").table(:class=>"itemListTable").td(:text=>fullUserName).wait_until_present.a.click

    sysAdmin    = $browser.table(:id => '_viewTemplate__kCuraScrollingDiv__groups_itemList_listTable').td(:text => 'System Administrators')
    smokeGroup  = $browser.table(:id => '_viewTemplate__kCuraScrollingDiv__groups_itemList_listTable').td(:text => groupName)

    if sysAdmin.exists? == true && smokeGroup.exists? == true    
        puts 'User Already Added to Groups'
        return true

    elsif sysAdmin.exists? == true && smokeGroup.exists? == false
        puts 'System Administrators Group Already Added'
        puts 'Adding User to Smoke Group'
        self.addGroup(groupName)
        return smokeGroup.exists?

    elsif sysAdmin.exists? == false && smokeGroup.exists? == true
        puts 'Smoke Group Already Added'
        puts 'Adding User to System Administrators Group'
        self.addGroup('System Administrators')
        return sysAdmin.exists?

    else
        puts 'Adding User to Smoke Group and System Administrators Group'
        self.addGroup(groupName)
        self.addGroup('System Administrators')
        return (sysAdmin.exists? == true && smokeGroup.exists? == true)
    end
	end

  #This below method is to add internal users to only to group Sys Admin
  def addUserToGroup_internal(fullUserName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users", 3).click
    iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").td(:text=>CreateInternalUsers::FullName).a.wait_until_present.click
    $browser.ElementByCss('#_viewTemplate__kCuraScrollingDiv__groups_itemList_ctl10_anchor', 3).wait_until_present.click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.td(:text=>"System Administrators").parent.tds[0].wait_until_present.click
      $browser.ElementByCss('#_ok2_button').click
    end
  end


  def createNewField(fieldName, fieldType)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Fields").wait_until_present.click
    iframe_main.a(:text =>"New Field").wait_until_present.click
    $browser.select_list(:id=>"_editTemplate__objectType_dropDownList").select "Document"
    $browser.text_field(:id=>"_editTemplate__name_textBox_textBox").set fieldName
    $browser.select_list(:id=>"_editTemplate__type_dropDownList").select fieldType
    $browser.select_list(:id=>"_editTemplate__isRequired_booleanDropDownList__dropDownList").select "No"
    begin
      $browser.select_list(:id=>"_editTemplate__allowGroupBy_booleanDropDownList__dropDownList").select "Yes"
    rescue Selenium::WebDriver::Error::UnhandledAlertError
      if $browser.alert.exists?
        $browser.alert.ok
      end
    end
    begin
      $browser.select_list(:id=>"_editTemplate__allowPivot_booleanDropDownList__dropDownList").select "Yes"
    rescue Selenium::WebDriver::Error::UnhandledAlertError
      if $browser.alert.exists?
        $browser.alert.ok
      end
    end
    begin
      $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    rescue Selenium::WebDriver::Error::UnhandledAlertError
      if $browser.alert.exists?
        $browser.alert.ok
      end
    end
  end

  def createNewChoices(choiceName1, choiceName2, fieldName)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Choices").wait_until_present.click
    iframe_main.a(:text =>"New Choice").wait_until_present.click
    sleep 2
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__type_dropDownList").select fieldName+" (Document)"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set choiceName1
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "10"
    sleep 5
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__ctrl_Checkbox").click
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__ctrl_Checkbox").click
    sleep 1
    $browser.checkbox(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__alt_Checkbox").click
    sleep 1
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__keyboardShortcut__key_DropDownList").select "R"
    sleep 1
    $browser.a(:id=>"_editTemplate_saveAndNew1_button").wait_until_present.click
    sleep 3
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__type_dropDownList").select fieldName+" (Document)"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set choiceName2
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "20"
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    sleep 3
  end

  def createNewLayout(layoutName, fieldName)
    $browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Layouts").wait_until_present.click
    iframe_main.a(:text =>"New Layout").wait_until_present.click
    $browser.select_list(:id=>"_editTemplate__kCuraScrollingDiv__objectType_dropDownList").select "Document"
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set layoutName
    $browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__order_int32TextBox_textBox").set "10"
    $browser.radio(:id=>"_editTemplate__kCuraScrollingDiv__copyfromprevious__radioButtonList_radioButtonList_0").set
    $browser.a(:id=>"_editTemplate_save1_button").wait_until_present.click
    $browser.a(:id=>"_viewTemplate__kCuraScrollingDiv__buildLayout_anchor").wait_until_present.click
    iframe_layout.div(:class=>"fieldsArea ng-scope").wait_until_present.click
    panel = iframe_layout.div(:class=>"ng-binding", :text=>fieldName)
    target = iframe_layout.div(:class=>"emptyField marginTop10")
    $browser.driver.action.click_and_hold(panel.wd).perform
    $browser.driver.action.move_to(target.wd).perform
    target.fire_event "onmouseup"
    iframe_layout.button(:text=>"Save").wait_until_present.click
    iframe_layout.select_list.wait_until_present.select "Radio Button List"
    label_pristine = iframe_layout.textarea(:class=>"marginRight3 ng-pristine ng-valid ng-scope ng-touched")
    label_dirty = iframe_layout.textarea(:class=>"marginRight3 ng-valid ng-scope ng-touched ng-dirty ng-valid-parse")
    if label_pristine.exists?
      label_pristine.set fieldName
    else
      label_dirty.set fieldName
    end
    iframe_layout.div(:class=>"artifactsViewTemplateHeader alignCenter").button(:text=>"Save and Close").wait_until_present.click
  end

  def setFields(fieldName)
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_ListOneBox").select fieldName
  	$browser.a(:id=>"_view__wizardTemplate__kCuraScrollingDiv__twoList_MoveSelectedToTwo_anchor").span.click
  end

  def setConditions(fieldName, operator, value)
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CriteriaField").select "Smoke Designation"
  	sleep 1
  	$browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CodeOperator").select "any of these"
  	$browser.input(:id=>"_view__wizardTemplate__kCuraScrollingDiv__criteriaGroup_ViewCriteriaNum0_CodeValue_Pick").click
  	$browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
    	$browser.td(:text=>WorkspaceElements::ChoiceName1).parent.checkbox(:id=>"checkbox_0").set
    	$browser.a(:text=>"Add").wait_until_present.click
    	$browser.a(:text=>"Set").wait_until_present.click
    end
    sleep 2
    $browser.a(:text=>"Save").wait_until_present.click
  end

  def createNewView(viewName, fieldName, operator, value)
  	$browser.div(:id=>"horizontal-subtabstrip").a(:text=>"Views").wait_until_present.click
    iframe_main.a(:text =>"New View").wait_until_present.click
    $browser.text_field(:id=>"_view__wizardTemplate__kCuraScrollingDiv__name_textBox_textBox").set viewName
    $browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__artifacts_dropDownList").select "Document"
    $browser.select_list(:id=>"_view__wizardTemplate__kCuraScrollingDiv__visualizationType_dropDownList").select "Standard List"
    $browser.a(:text=>"Next").wait_until_present.click
    self.setFields("Edit")
    self.setFields("Control Number")
    self.setFields("Smoke Designation")
    self.setFields("Group Identifier")
    $browser.a(:text=>"Next").wait_until_present.click
    self.setConditions(fieldName, operator, value)
  end

  def createSearchProfile(savedSearchName, folderName)
    iframe_folder.img(:id=>"_paneCollection_searchContainer_Icon").wait_until_present.click
  	iframe_main.a(:id=>"_newSearch_button").wait_until_present.click
    iframe_main.text_field(:id=>"_name_textBox_textBox").set savedSearchName
  	iframe_main.label(:text=>"Selected Folders").parent.radio.set
  	iframe_main.a(:text=>"Select Folders").click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.span(:text=>folderName).parent.checkbox.set
      $browser.a(:id=>"_ok_button").click
    end
    iframe_main.select_list(:id=>"_twoList_ListOneBox").select "Has Images"
    iframe_main.a(:id=>"_twoList_MoveSelectedToTwo_anchor").span.click
    iframe_main.select_list(:id=>"_twoList_ListOneBox").select "Extracted Text"
    iframe_main.a(:id=>"_twoList_MoveSelectedToTwo_anchor").span.click
    iframe_main.a(:id=>"_saveAndSearchButton_button").click
  end

  def savedSearchResultCount
    iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present
    return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def viewResponsiveDocs(viewName)
    iframe_folder.img(:id=>"_paneCollection_folder_Icon").wait_until_present.click
  	iframe_paneCollection.span(:text=>WorkspaceElements::FolderName).click
    iframe_main.select_list(:id=>"ctl00_viewsDropDown").wait_until_present.select viewName
  end

  def verifyResponsiveDocuments
    iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").tr.wait_until_present
    return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def verifyResponsiveDocumentsInclFamily
  	 iframe_main.select_list(:id=>"ctl00_FamilyDropdown").select "Include Family"
  	 iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").tr.wait_until_present
  	 return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").trs.count
  end

  def getGroupNameElement(groupName)
  	iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").wait_until_present
  	return iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").td(:text=>groupName)
  end

  def getUserNameElement(userName)
    iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").wait_until_present
    return iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").td(:text=>userName)
  end

  def getWorkspaceNameElement(workspaceName)
    iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").wait_until_present
    return iframe_main.table(:id=>"ctl00_ctl00_itemList_listTable").a(:text=>workspaceName)
  end

  def getServerName(serverName)
    return $browser.td(:text=>serverName)
  end

  def getdtSearchName(dtSearchName)
    return iframe_main.a(:text=> dtSearchName)
  end

end
