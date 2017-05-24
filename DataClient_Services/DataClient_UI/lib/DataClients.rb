require_relative 'includes'
require_relative 'WatirWrapperMethods'

class DataClientsUI < WatirWrapperMethods

    def add_new_data_client(dataClientDetails, custodianDetails, repository)
        self.css_by_text('md-tab-item', 'DATA CLIENTS')
        $browser.button(:id=>'addDataClient').click
        self.details(dataClientDetails)
        $browser.span(:class=>'ng-scope', :text=>'Custodians').click
        $browser.button(:id=>'addCustodian').click
        self.custodians(custodianDetails)
        self.repositories(repository)
    end
    
    def details(dataClientDetails)
        $browser.button(:id=>'dataClientDetailEdit').click
        self.wait_while_spinning
        
        #Editing the data client name
        $browser.text_field(:id=>'dataClientName').set dataClientDetails['name']
        self.wait_while_spinning

        #Setting the data segregation type
        $browser.label(:text, 'Data Segregation').parent.click
        self.wait_while_spinning
        $browser.element(:tag_name => 'md-option', :text => dataClientDetails['segregation']).click

        #Setting the custodian name format
        $browser.label(:text, 'Custodian Name Format').parent.click
        $browser.div(:text, dataClientDetails['format']).click
        $browser.button(:id=>'dataClientDetailEdit').click
    end

    def custodians(custodiansDetails)
        #Adding/Setting Custodian to the new Data Client
        $browser.button(:id=>'custodianEdit').click
        $browser.text_field(:id=>'custodianFirstName').set custodiansDetails['firstName']
        self.wait_while_spinning
        $browser.text_field(:id=>'custodianMiddleName').set custodiansDetails['middleName']
        self.wait_while_spinning
        $browser.text_field(:id=>'custodianLastName').set custodiansDetails['lastName']
        self.wait_while_spinning
        $browser.text_field(:id=>'custodianDisplayName').set custodiansDetails['displayName']
        self.wait_while_spinning
        $browser.text_field(:id=>'custodianUserIdentifier').set custodiansDetails['identifier']
        self.wait_while_spinning
        $browser.button(:id=>'custodianEdit').click
    end

    def repositories(repository)
        #Adding Repositories to the new Data Client
        $browser.span(:class=>'ng-scope', :text=>'Repositories').click
        $browser.button(:id=>'repositoryEdit').click
        $browser.td(:text=>repository).parent.div.click
        self.wait_while_spinning
        $browser.button(:id=>'repositoryEdit').click
    end

    def get_new_data_client_name_from_list(dataClientName)
        self.wait_while_spinning
        self.table_scroll_down(dataClientName, 'dataClientsTable')
        return $browser.table(:id=>'dataClientsTable').td(:text=>dataClientName)
    end

    def search_data_client_by_name(dataClientName)
        $browser.text_field(:id=>'dataClientSearch').set dataClientName
        $browser.td(:text=>dataClientName).parent.click
    end

    def data_client_edit(dataClientName, dataClientDetails, custodianDetails, repository, custodianName)
        self.css_by_text('md-tab-item', 'DATA CLIENTS')
        self.search_data_client_by_name(dataClientName)
        self.get_new_data_client_name_from_list(dataClientName).parent.click
        self.details(dataClientDetails)
        $browser.span(:class=>'ng-scope', :text=>'Custodians').click
        $browser.td(:text=>custodianName['firstName']).parent.click
        self.custodians(custodianDetails)
        self.repositories(repository)
    end

    def add_one_custodian(custodiansDetails)
        self.search_data_client_by_name(DataClientEdit::Details['name'])
        $browser.span(:class=>'ng-scope', :text=>'Custodians').click
        $browser.button(:id=>'addCustodian').click
        self.wait_while_spinning
        self.custodians(custodiansDetails)
        self.wait_while_spinning
    end

    def remove_one_n_add_another_repository(repository, repositoryNew)
        $browser.span(:class=>'ng-scope', :text=>'Repositories').click
        $browser.button(:id=>'repositoryEdit').click
        $browser.td(:text=>repository).parent.div.click
        $browser.td(:text=>repositoryNew).parent.div.click
        $browser.button(:id=>'repositoryEdit').click
    end

    def add_project_to_data_client(projectCode)
        self.search_data_client_by_name(DataClientEdit::Details['name'])
        $browser.button(:id=>'projectEdit').click
        self.search_text_box('projectSearch', projectCode)
        # self.table_scroll_down(projectCode, "projectTable")
        $browser.td(:text=>projectCode).parent.div.click
        self.wait_while_spinning
        $browser.button(:id=>'projectEdit').click
        wait_while_spinning
    end

    def table_scroll_down(searchString, tableName)
        $browser.table(:id=>tableName).tr.click
        begin
            i=0
            $browser.table(:id=>tableName).tr.click
            while !($browser.td(:text=>searchString).exists?) && i<3000 do
                $browser.send_keys :space
                i=i+1
            end
        rescue => exception
            exception == 'error'
        end
        if $browser.td(:text=>searchString).exists?
            puts 'searched item found'
        else
            puts 'searched item NOT found'
        end
    end

    def search_text_box(type, string)
        $browser.text_field(:id=>type).set string
        $browser.td(:text=>string).parent.click
    end

    def select_custodians(custodianName)
        wait_while_spinning
        $browser.span(:text=>'Custodians').click
        $browser.table(:id=>'custodiansTable').td(:text=>custodianName).parent.click
    end

    def edit_custom_attribute
        $browser.button(:id=>'custodianDetailAttributes').click
        $browser.button(:id=>'attributeEdit').click # opening attribute for Editing
    end

    def add_new_custom_attribute
        $browser.button(:id=>'attributeAdd').click
    end

    def attribute_rows
        return $browser.elements(:css, "#customAttributesDialog div[ng-repeat='attribute in attributes track by $index']")
    end

    def last_attribute_row
        return self.attribute_rows[attribute_rows.count - 1]
    end

    def custodian_attribute_close
        $browser.button(:id=>'attributeEdit').click
        $browser.element(:id=>'customAttributesDialog').button(:text=>'close').click
        self.wait_while_spinning
        sleep 0.5
    end

    def set_attribute_name(attributeName)
        self.last_attribute_row.text_field(:css=>"[ng-model='attribute.key']").set attributeName
    end

    def get_attribute_name(rowsFromBottom)
        return self.attribute_rows[attribute_rows.count - rowsFromBottom].text_field(:css=>"[ng-model='attribute.key']").value
    end
    
    def set_attribute_type(attributeType)
        attributeMenuButton = self.last_attribute_row.element(:css=>"[ng-click='$mdOpenMenu($event)']")
        attributeMenuButton.click
        attributeMenuContainer = $browser.element(:id=>attributeMenuButton.attribute_value('aria-owns'))
        attributeMenuContainer.element(:text => attributeType).click
    end

    def set_attribute_value(attributeType, attributeValue)
        if attributeType == 'Date'
            self.last_attribute_row.element(:css=>"[ng-model='attribute.value']").text_field.set attributeValue
        elsif attributeType == 'True/False'
            self.last_attribute_row.element(:css=>"[ng-model='attribute.value']").click
        else
            self.last_attribute_row.text_field(:css=>"[ng-model='attribute.value']").set attributeValue
        end
    end
    
    def set_custom_attributes(custodianName, attributeName, attributeValue, attributeType)
        self.search_data_client_by_name(DataClientEdit::Details['name'])
        self.select_custodians(custodianName)
        self.edit_custom_attribute
        self.add_new_custom_attribute
        self.set_attribute_name(attributeName)
        self.set_attribute_type(attributeType)
        self.set_attribute_value(attributeType, attributeValue)
        self.custodian_attribute_close
    end

    def custom_attributes_validations
        $browser.button(:id=>'custodianDetailAttributes').click
        if (
            self.get_attribute_name(1) == 'BooleanAttribute' and
            self.get_attribute_name(2) == 'DateAttribute' and
            self.get_attribute_name(3) == 'NumericAttribute' and
            self.get_attribute_name(4) == 'TextAttribute' and
            self.attribute_rows.count >= 4
            )
            self.custodian_attribute_close
            return true
        else
            self.custodian_attribute_close
            return false
        end
    end
end

class Custom_Custodian_Attribute < DataClientsUI

    def get_custodian_tab(dataClientName)
        self.css_by_text('md-tab-item', 'DATA CLIENTS')
        self.search_data_client_by_name(dataClientName)
        self.wait_while_spinning
        $browser.span(:class=>'ng-scope', :text=>'Custodians').click
    end

    def grid_attribute_edit(dataClientName)
        self.get_custodian_tab(dataClientName)
        $browser.button(:id=>"custodianCustomAttributes").click
        $browser.button(:id=>'attributeEdit').click
        # self.add_new_custom_attribute
    end

    def grid_attribute_add(attributeName, attributeType)
        self.add_new_custom_attribute
        $browser.text_field(:css=>"[ng-model='addAttributeName']").set attributeName
        $browser.element(:css=>"[ng-click='$mdOpenMenu($event)']").click
        $browser.span(:text => attributeType).click
        $browser.element(:css=>'#customGridAttributesDialog > md-dialog-actions > div > button').click
        # $browser.element(:tag_name => 'md-icon', :text=>'add').click
        self.wait_while_spinning
        count_attributes = $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]').count
        $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]')[count_attributes-1].click
    end

    def grid_attribute_close
        self.wait_while_spinning
        $browser.button(:id=>'attributeEdit').click
        self.wait_while_spinning
        $browser.element(:css=>'#customGridAttributesDialog > md-toolbar > div > button').click
        sleep 0.5
    end

    def grid_attribute_columns(columnName)
        return $browser.element(:tag_name=>'md-virtual-repeat-container', :id =>'custodiansCardTable').tr.th(:text=>columnName).exists?
    end

    def grid_attribute_delete(attributeName)
        $browser.element(:tag_name=> 'md-dialog-content', :id => 'dialogContent_customGridAttributesDialog').div(:text =>attributeName).parent.parent.button.click
    end

    def wait_until_undo_delete_clears
        $browser.span(:text =>'Attribute deleted').wait_while_present
    end

    def checkbox_all_available_attributes
        count_attributes = $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]').count
        begin
            i = 0
            while i < count_attributes
                $browser.elements(:css=>'#dialogContent_customGridAttributesDialog div div [ng-model]')[i].click
                i=i+1
            end
        end
    end

end