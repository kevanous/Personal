require_relative '../lib/includes'


describe 'Data Client Tab' do
	before {
        @dataClientsUI = DataClientsUI.new
        @sql_dataClients = DataClient_SQL.new
        @custom_attribute_gridview = Custom_Custodian_Attribute.new
		$url = Urls.const_get('TestUrl')
        $browser.goto $url
        }

    context 'Adding a new Data Client:' do
        before do
            @dataClientsUI.add_new_data_client(DataClient::Details, DataClient::Custodians, DataClient::Repositories)
            $browser.refresh
        end
        it 'creates a record of the new data client in the UI' do
            expect(@dataClientsUI.get_new_data_client_name_from_list(DataClient::Details['name'])).to exist
        end
    end

    context 'Searching for a Data Client in search box' do
        before do
            @dataClientsUI.search_data_client_by_name(DataClient::Details['name'])
        end
        it 'results in the searched data client in the result set' do
            expect(@dataClientsUI.get_new_data_client_name_from_list(DataClient::Details['name']).text).to eq (DataClient::Details['name'])
        end
    end

    context 'Editing Details of an existing Data Client' do
        before do
            @dataClientsUI.data_client_edit(DataClient::Details['name'], DataClientEdit::Details, DataClientEdit::Custodians, DataClientEdit::Repositories2, DataClient::Custodians)
            @dataClientsUI.search_data_client_by_name(DataClientEdit::Details['name'])
        end

        it 'allows the name, segregation type and custodian name format of the data client to be edited' do
            expect(@dataClientsUI.get_new_data_client_name_from_list(DataClientEdit::Details['name']).text).to eq (DataClientEdit::Details['name'])
        end
    end

    context 'Adding a single custodian to an existing Data Client' do
        before  do
            @dataClientsUI.search_data_client_by_name(DataClientEdit::Details['name'])
        end
        it 'results in that data client being associated with the newly created custodian' do
            @dataClientsUI.add_one_custodian(CustodianAdd::Custodians1)
            expect($browser.td(:text=>CustodianAdd::Custodians1['firstName']).text).to eq CustodianAdd::Custodians1['firstName']
        end
    end

    context 'Adding custom attributes to the custodian' do
        before do
            @dataClientsUI.set_custom_attributes(DataClientEdit::Custodians['firstName'], 'TextAttribute', 'TextValue', 'Text')
            @dataClientsUI.set_custom_attributes(DataClientEdit::Custodians['firstName'], 'NumericAttribute', 123908, 'Numeric')
            @dataClientsUI.set_custom_attributes(DataClientEdit::Custodians['firstName'], 'DateAttribute', '11/17/2016', 'Date')
            @dataClientsUI.set_custom_attributes(DataClientEdit::Custodians['firstName'], 'BooleanAttribute', 'True/False', 'True/False' )
        end
        it 'adds custom attribute in the format of text, numeric, true/false logic and date' do
            expect( @dataClientsUI.custom_attributes_validations).to eq true
        end
    end

    context 'Adding multiple custodians to an existing Data Client' do
        before do
            @dataClientsUI.add_one_custodian(CustodianAdd::Custodians2)
            @dataClientsUI.add_one_custodian(CustodianAdd::Custodians3)
        end

        it 'results in that data client being associated with the newly created custodians' do
            expect($browser.td(:text=>CustodianAdd::Custodians2['firstName']).text).to eq CustodianAdd::Custodians2['firstName']
            expect($browser.td(:text=>CustodianAdd::Custodians3['firstName']).text).to eq CustodianAdd::Custodians3['firstName']
        end
    end

    context 'Adding custom attributes via the grid view that propagates to all the custodians in a data client' do
        before do
            # @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::SampleDetails['name'])
            @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::Details['name'])
            @custom_attribute_gridview.grid_attribute_add('TextName_Grid', 'Text')
            @custom_attribute_gridview.grid_attribute_add('NumericName_Grid', 'Numeric')
            @custom_attribute_gridview.grid_attribute_add('DateName_Grid', 'Date')
            @custom_attribute_gridview.grid_attribute_add('Boolean_Name_Grid', 'True/False')
            @custom_attribute_gridview.grid_attribute_close
        end

        it 'adds the new custom attributes as fields in the custodians tab of the selected data client' do
            expect(@custom_attribute_gridview.grid_attribute_columns('TextName_Grid')).to be true
            expect(@custom_attribute_gridview.grid_attribute_columns('NumericName_Grid')).to be true
            expect(@custom_attribute_gridview.grid_attribute_columns('DateName_Grid')).to be true
            expect(@custom_attribute_gridview.grid_attribute_columns('Boolean_Name_Grid')).to be true
        end
    end

    context 'Deleting custom attributes via the grid view that propagates to all custodians in a data client' do
        before do
            # @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::SampleDetails['name'])
            @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::Details['name'])
            @custom_attribute_gridview.grid_attribute_delete('TextName_Grid')
            @custom_attribute_gridview.wait_until_undo_delete_clears            
            @custom_attribute_gridview.grid_attribute_delete('DateName_Grid')
            @custom_attribute_gridview.wait_until_undo_delete_clears
            @custom_attribute_gridview.grid_attribute_close
            # @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::SampleDetails['name'])
            @custom_attribute_gridview.grid_attribute_edit(DataClientEdit::Details['name'])
            # @custom_attribute_gridview.checkbox_all_available_attributes

        end

        it 'deletes the new custom attributes from the custodians tab fields of the selected data client' do
            expect(@custom_attribute_gridview.grid_attribute_columns('TextName_Grid')).to be false
            expect(@custom_attribute_gridview.grid_attribute_columns('NumericName_Grid')).to be true
            expect(@custom_attribute_gridview.grid_attribute_columns('DateName_Grid')).to be false
            expect(@custom_attribute_gridview.grid_attribute_columns('Boolean_Name_Grid')).to be true
        end
    end

    context 'Editing an existing repository of the data client to a different repository' do
        before  do
            @dataClientsUI.search_data_client_by_name(DataClientEdit::Details['name'])
            @dataClientsUI.remove_one_n_add_another_repository(DataClient::Repositories, DataClientEdit::Repositories3)
        end
        it 'results in that data client being associated with the new repository' do
            expect($browser.td(:text=>DataClientEdit::Repositories3)).to exist   
        end
    end

    context 'Adding a project to the newly created Data Client' do
        before do
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode1)
        end
        it 'creates a record of a project added to the data client' do
            expect($browser.td(:text=>ProjectCodes::ProjectCode1).visible?).to be true
        end
    end

    context 'Adding multiple projects to the selected Data Client' do
        before do
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode2)
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode3)
            @dataClientsUI.add_project_to_data_client(ProjectCodes::ProjectCode4)
        end
        it 'creates a record of all the projects that are associated with the selected data client' do
            @dataClientsUI.search_data_client_by_name(DataClientEdit::Details['name'])
            @dataClientsUI.search_text_box('projectSearch', '')
            expect($browser.td(:text=>ProjectCodes::ProjectCode1)).to exist
            expect($browser.td(:text=>ProjectCodes::ProjectCode2)).to exist
            expect($browser.td(:text=>ProjectCodes::ProjectCode3)).to exist
            expect($browser.td(:text=>ProjectCodes::ProjectCode4)).to exist
        end
    end

    context 'meets all set requirements, as per above contexts' do
        it '' do
        end
    end

end