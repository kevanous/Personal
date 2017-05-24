require_relative '../lib/includes'

describe 'Cleanup for reusability:' do
    before {
        @dataClientsUI = DataClientsUI.new
        @dataClientServices = DataClientServices.new
        $url = Urls.const_get('TestUrl')
        $browser.goto $url
    }

    context 'Removing the projects linked with the data client' do
        before do
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode1)
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode2)
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode3)
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode4)
        end
        it 'removes all association of the project with the selected data client' do
            @dataClientsUI.search_data_client_by_name(DataClientEdit::Details['name'])
            expect($browser.td(:text=>ProjectCodes::ProjectCode1).visible?).to be false
            expect($browser.td(:text=>ProjectCodes::ProjectCode2).exists?).to be false
            expect($browser.td(:text=>ProjectCodes::ProjectCode3).exists?).to be false
            expect($browser.td(:text=>ProjectCodes::ProjectCode4).exists?).to be false
        end
    end

    context 'Removing the repositories linked with the data client' do
        before do
            @dataClientServices.repository_delete(@dataClientServices.get_data_client_id)
        end
        it 'removes all the data client repositories linked with newly created data Client ID' do
            expect(@dataClientServices.get_repositories(@dataClientServices.get_data_client_id)['value']).to eq [] # we would expect an empty array when no record exists
        end
    end

    context 'Removing custodians linked with the data client' do
        before do
            @dataClientServices.custodians_delete(@dataClientServices.get_data_client_id)
        end
        it 'deletes all custodians linked with newly created data Client ID' do
            expect(@dataClientServices.custodians_linked_with_data_clients(@dataClientServices.get_data_client_id)['value']).to eq [] # we would expect an empty array when no record exists
        end
    end

    context 'Deleting the data client' do
        before do
             @dataClientServices.data_client_delete(@dataClientServices.get_data_client_id)
        end
        it 'deletes the newly created data client record' do
            expect(@dataClientServices.get_data_clients_body).to eq "" # we would expect an empty string when no record exists
        end
    end

    context 'This test environment is reset for any number of repeated rspec test runs' do
        it '' do
        end
    end
end