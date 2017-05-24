require_relative 'includes'
require_relative 'DataClients'

class ProjectsUI < DataClientsUI
    # def initialize
    #     @framework = Framework.new
    # end

    def select_projects_tab
        css_by_text('md-tab-item', 'PROJECTS')
    end

    def select_projects(projectName)
        $browser.element(:css=>"#tab-content-1").text_field(:id=>'projectSearch').set projectName
        $browser.element(:css=>"#tab-content-1").td(:text=>projectName).parent.click
    end

    def data_client_edit_lock
        $browser.buttons(:id=>"dataClientListEdit")[1].click
    end

    def tick_checkbox_data_client_by_name(dataClientName)
        $browser.element(:css=>"#tab-content-1").text_field(:id=>'dataClientSearch').set dataClientName
        wait_while_spinning
        if self.checkbox_check(dataClientName) == false
            $browser.element(:css=>"#tab-content-1").td(:text=>dataClientName).parent.td.click
        else 
            puts "Already checked"
        end
    end

    def untick_checkbox_data_client_by_name(dataClientName)
        $browser.element(:css=>"#tab-content-1").text_field(:id=>'dataClientSearch').set dataClientName
        wait_while_spinning
        if self.checkbox_check(dataClientName) == true
            $browser.element(:css=>"#tab-content-1").td(:text=>dataClientName).parent.td.click
        else 
            puts "Already un-checked"
        end
    end

    def checkbox_check(dataClientName)
        checkbox = $browser.element(:css=>"#tab-content-1").td(:text=>dataClientName).parent.td.html
        return checkbox.include? 'checked="checked"'
    end

    def add_data_client_to_project(projectName, dataClientName)
        self.select_projects_tab
        self.select_projects(projectName)
        self.data_client_edit_lock
        tick_checkbox_data_client_by_name(dataClientName)
        wait_while_spinning
        self.data_client_edit_lock
    end

    def remove_data_client_to_project(projectName, dataClientName)
        self.select_projects_tab
        self.select_projects(projectName)
        self.data_client_edit_lock
        untick_checkbox_data_client_by_name(dataClientName)
        wait_while_spinning
        self.data_client_edit_lock
    end

    def add_multiple_data_clients_to_project(dataClientName)
        tick_checkbox_data_client_by_name(dataClientName)
    end

    def data_client_link_project_validation(dataClientName)
        $browser.element(:css=>"#tab-content-1").text_field(:id=>'dataClientSearch').set ""
        return $browser.element(:css=>"#tab-content-1").table(:id=>"dataClientsTable").td(:text=>dataClientName).exists?
    end
end




