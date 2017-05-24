# require_relative 'includes'
# require_relative 'DataClients'


# class Custom_Custodian_Attribute <  DataClientsUI


#   def get_custodian_tab(dataClientName)
#     self.css_by_text('md-tab-item', 'DATA CLIENTS')
#     self.search_data_client_by_name(dataClientName)
#     self.wait_while_spinning
#     $browser.span(:class=>'ng-scope', :text=>'Custodians').click
#   end

#   def grid_attributes_edit(dataClientName)
#     self.get_custodian_tab(dataClientName)
#     $browser.button(:id=>"custodianCustomAttributes").click
#     $browser.button(:id=>'attributeEdit').click
#   end

#   def grid_attribute_add(attributeName, attributeType)
#     self.add_new_custom_attribute
#     $browser.text_field(:css=>"[ng-model='addAttributeName']").set attributeName
#     $browser.element(:css=>"[ng-click='$mdOpenMenu($event)']").click
#     $browser.span(:text => attributeType).click
#     $browser.element(:css=>'#customGridAttributesDialog > md-dialog-actions > div > button').click
#     wait_while_spinning
#     count_attributes = $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]').count
#     $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]')[count_attributes-1].click
#   end

#   def grid_attribute_close
#     $browser.button(:id=>'attributeEdit').click
#     wait_while_spinning
#     $browser.element(:css=>'#customGridAttributesDialog > md-toolbar > div > button').click
#   end

# end

  #  def grid_attribute_delete(attributeName)
  #       $browser.element(:tag_name=> 'md-dialog-content', :id => 'dialogContent_customGridAttributesDialog').div(:text =>attributeName).parent.parent.button.click
  #   end

  #   def wait_until_undo_delete_clears
  #       $browser.element(:css=>'#customGridAttributesDialog > md-dialog-actions > div > md-input-container').wait_while_present
  #   end