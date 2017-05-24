require 'rubygems'
require 'bundler/setup'
require 'byebug'
require_relative 'RelativityWorkspace'
require_relative 'InputData'

class Login_N_CreateNewWorkspace < RelativityWorkspace

	def relativityLogin(userName, password)
		if $browser.text_field(:id=>"_email").exists? == true
			$browser.text_field(:id=>"_email").wait_until_present.set(userName)
			$browser.button(:id=>"continue").click
			$browser.text_field(:id=>"_password__password_TextBox").wait_until_present.set(password)
			$browser.button(:id=>"_login").click
		else
			puts "no login information prompted, but continuing forward on windows credential"
		end
  	end

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

	# Method Updated for Rel 94 Testing - Working
	# Creates a Workspace with Parameters input of Name, Client and Matter
 	def createNewWorkspace(workspaceName, clientName, matterName)
		iframe_main.div(:id => "_main").a(:text => "New Workspace").click
		$browser.text_field(:id=>"_editTemplate__kCuraScrollingDiv__name_textBox_textBox").set(workspaceName)
		$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__client_pick").click
		self.setInWindow(clientName)
		$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__matter_pick").click
		self.setInWindow(matterName)
		$browser.input(:id=>"_editTemplate__kCuraScrollingDiv__template_pick").click
		self.setInWindow("kCura Starter Template")
		$browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__resourceGroup_dropDownList").select "Default"
		$browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__defaultDocumentLocation_dropDownList").options[1].select
		$browser.select_list(:id => "_editTemplate__kCuraScrollingDiv__defaultCacheLocation_dropDownList").options[1].select
		$browser.a(:id=> "_editTemplate_save1_button").click
		$browser.wait_until(120) {$browser.iframe(:id=>"ListTemplateFrame").table(:class=>"itemListTable").exists?}
	end

 	def newWorkspaceCreated(workspaceName)
		return iframe_main.td(:text=>workspaceName).exists?
 	end

 	def getfieldName(parentIdName, searchField)
    	SelectSearchName93(parentIdName, searchField)
 		return $browser.tr(:id=>"_name").tds[1].text
 	end

 	def addSmokeGroup(workspaceAdmin_tab, groupName)
 		get_WorkspaceAdmin_tab(workspaceAdmin_tab)
 		$browser.a(:id=>"_viewTemplate__kCuraScrollingDiv__manageWorspacePermissions_anchor").wait_until_present.click
		$browser.window(:index => 1).wait_until_present
   		$browser.window(:index => 1).use do
			if $browser.span(:text=>groupName).exists? == false				
				$browser.a(:id=>"_addremovegroups",:class=>"button primary").wait_until_present.click
				$browser.span(:text=> groupName).parent.wait_until_present.click
				$browser.span(:text => "Add (1)").wait_until_present.click
				$browser.button(:id=>"_addRemoveSaveButton").span(:class => "ui-button-text",:text=>"Save").click
			end
    	end
		$browser.window(:index => 1).wait_until_present
		$browser.window(:index => 1).use do
			$browser.div(:id=>"toast-container").div(:class=>"toast-message").wait_while_present
			$browser.div(:id=>"content-main").span(:text=>groupName).parent.parent.spans[1].a(:text=>"Preview").click
		end
		$browser.window(:index => 1).wait_while_present
  	end

	def previewNoticationExists
		return $browser.table(:id=>"Table1").td(:text=>"Previewing as group: Smoke Group").exists?
	end

	def firstTabName
		return $browser.div(:id=>"horizontal-tabstrip").as[0].text
	end

	def otherTabsExists
		return $browser.div(:id=>"horizontal-tabstrip").li(:class=>"relativity-tab horizontal-tab ng-scope active").as[3].exists?
	end

	def returnsToWorkspaceDetails
		$browser.input(:id=>"EndPreviewSessionButton").click
		$browser.div(:id=>"_main").wait_until_present
		return $browser.div(:id=>"_viewTemplate__kCuraScrollingDiv").h2(:text=>"Workspace Information").exists?
	end

	def switch_ui(type)
		$browser.span(:title =>"User Dropdown Menu").click
		if $browser.a(:text => type).exists? == true
			$browser.a(:text => type).click
			puts "#{type} is completed"
		else
			puts "Already has the #{type}"
		end
	end

end
