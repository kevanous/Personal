require 'rubygems'
require 'bundler/setup'
require 'byebug'
require_relative 'RelativityWorkspace'
require_relative 'AutomationSmokeTest'
require_relative 'InputData'

class DeleteSmokeWorkspace < RelativityWorkspace

  def delete_dtSearchIndex(dtSearchName)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' %"Search Indexes").click
    while iframe_main.a(:text=> dtSearchName).exists? == true do
      iframe_main.a(:text=> dtSearchName).wait_until_present.click
      $browser.a(:text=>"Delete").wait_until_present.click
      $browser.window(:index => 1).wait_until_present
      $browser.window(:index => 1).use do
        $browser.a(:text=>"Delete").wait_until_present.click
      end
      iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").wait_until_present
    end
  end

  def pick_Delete_Go_Ok
    iframe_main.div(:id=>"ctl00_BottomActionBar").select_list.select "Delete"
    iframe_main.a(:id=>"ctl00_go_button").click
    $browser.window(:index => 1).wait_until_present
    $browser.window(:index => 1).use do
      $browser.a(:id=>"_ok_button").click
    end
  end

  def delete_Group(groupName)
  	$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Groups", 3).click
  	AutomationSmokeTest.new.getGroupNameElement(groupName).parent.td.click
  	self.pick_Delete_Go_Ok
  end

  def delete_User(userName)
    byebug
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li:nth-child(3) > a', 3).click
  	$browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)' % "Users", 3).click
    iframe_main.a(:text =>userName).parent.parent.tds[0].wait_until_present.click
    iframe_main.div(:id=>"ctl00_BottomActionBar").select_list.select "Delete"
    self.pick_Delete_Go_Ok
  end

  def delete_Workspaces
    while AutomationSmokeTest.new.getWorkspaceNameElement(RelativityWorkspaceItems::WorkspaceNameSmoke).exists? == true do
      smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      TabAccess(ApplicationNames::WorkspaceAdmin)
      $browser.ElementByCss('#_viewTemplate_delete1_button').click
      $browser.window(:index => 1).wait_until_present
      $browser.window(:index => 1).use do
        $browser.a(:id=>"_ok_button").click
      end
    end
  end

  def remove_resourcepool(serverName, serverType)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Resource Pools").click
    iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").a(:text=>"Default").wait_until_present.click
    $browser.td(:class => "viewFieldValue").span(:text => "Default").wait_until_present
    if $browser.td(:text=>serverName).exists? == true
      $browser.td(:text=>serverName).parent.tds[0].click
      $browser.span(:text=>serverType).parent.spans[2].a(:text=>"Remove").wait_until_present.click
      sleep 3
      if $browser.alert.exists? == true
        $browser.alert.ok
        sleep 3
      elsif $browser.window(:index => 1).exists? == true
        $browser.window(:index => 1).use do
          $browser.a(:text => "Remove").wait_until_present.click
          sleep 3
        end
      end
    end
  end

  def remove_resourcepool_WMS(serverName, serverType)
    $browser.ElementByCss('#horizontal-subtabstrip > ul > li > a:contains(%s)'% "Resource Pools").click
    iframe_main.table(:id=>"ctl00_viewRenderer_itemList_listTable").a(:text=>"Default").wait_until_present.click
    $browser.td(:class => "viewFieldValue").span(:text => "Default").wait_until_present
    if $browser.td(:text=>serverName).exists? == true
      $browser.span(:text => serverType).parent.spans[2].a(:text=>"Remove").wait_until_present.click
      sleep 3
      if $browser.alert.exists?
        $browser.alert.ok
        sleep 3
      end
    end
  end

end