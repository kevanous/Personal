require_relative '../lib/includes'


describe 'Projects Tab' do
	before {
        @dataClientsUI = DataClientsUI.new
        @projectsUI = ProjectsUI.new
        @sql_dataClients = DataClient_SQL.new
		    $url = Urls.const_get('TestUrl')
        $browser.goto $url
        }

    context 'Adding a single data client to a project' do
        before do
            @projectsUI.add_data_client_to_project(ProjectCodes::ProjectCode5, DataClientEdit::Details['name'])
        end
        it 'associates a selected project with a data client' do
            expect(@projectsUI.data_client_link_project_validation(DataClientEdit::Details['name'])).to be true
        end
    end

    context 'Adding multiple data clients to a project' do
        before do
            @projectsUI.add_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient1)
            @projectsUI.add_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient2)
            @projectsUI.add_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient3)
        end
        it 'associates a project with multiple data clients' do
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient1)).to be true
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient2)).to be true
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient3)).to be true
        end
    end

    context 'Removing the association between project and data clients' do
        before do
            @projectsUI.remove_data_client_to_project(ProjectCodes::ProjectCode5, DataClientEdit::Details['name'])
            @projectsUI.remove_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient1)
            @projectsUI.remove_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient2)
            @projectsUI.remove_data_client_to_project(ProjectCodes::ProjectCode5, DataClientsName::DataClient3)
        end
        it "removes the association between a project and all the data clients under it" do
            expect(@projectsUI.data_client_link_project_validation(DataClientEdit::Details['name'])).to be false
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient1)).to be false
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient2)).to be false
            expect(@projectsUI.data_client_link_project_validation(DataClientsName::DataClient3)).to be false
        end
    end
end
