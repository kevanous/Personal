require_relative 'includes'

class DataClientServices
    $DataClientServiceURi = 'http://mtpctscid304.consilio.com/DataClientService/v1/odata/'
    $ProjectServiceURi = 'http://MTPCTSCID309.consilio.com/projectservice/v1/odata/'
                        # https://globalservices.consilio.com/projectservice/v1/odata/

    def dataClients_by_name(name)
        return $DataClientServiceURi+"DataClients?$filter=Name eq '#{name}'"
    end

    def get_data_client_id
        @dataClientsOdata = (RestServiceBase.new(dataClients_by_name(DataClientEdit::Details['name'])))
		@dataClientsOdata.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
        @dataClient_getBody = @dataClientsOdata.get[:body]
        @parsed_body = JSON.parse(@dataClient_getBody)
        $dataClient_ID = @parsed_body['value'][0]['Id']
        return @parsed_body['value'][0]['Id']
    end


    def custodians_linked_with_data_clients(dataClientID)
        custodianURI = $DataClientServiceURi+"Custodians?$filter=DataClientId eq #{dataClientID}"
        get_custodians = (RestServiceBase.new(custodianURI))
        get_custodians.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
        return JSON.parse(get_custodians.get[:body])
    end

    def custodians_delete(dataClientID)
        cust_count = custodians_linked_with_data_clients(dataClientID)['value'].count
        begin
            a=0
            while a < cust_count do
                custodians = $DataClientServiceURi+"Custodians(#{self.custodians_linked_with_data_clients(dataClientID)['value'][0]['Id']})?deletedBy=QATester"
                custodiansService = (RestServiceBase.new(custodians))
                custodiansService.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
                custodiansService.delete
                a = a+1
            end                
            rescue => exception
                exception == "Error"
        end
    end

    def get_repositories(dataClientID)
        repositoryURI = $DataClientServiceURi+"DataClientRepositories?$filter=DataClientId eq #{dataClientID}"
        get_repositories = (RestServiceBase.new(repositoryURI))
        get_repositories.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
        return JSON.parse(get_repositories.get[:body])
    end 

    def repository_delete(dataClientID)
        repository_count = get_repositories(dataClientID)['value'].count
        begin
            a=0
            while a < repository_count do
                dataClientRepository = $DataClientServiceURi+"DataClientRepositories(#{get_repositories(dataClientID)["value"][0]["Id"]})?deletedBy=QATester"
                dataClientRepositoryService = (RestServiceBase.new(dataClientRepository))
                dataClientRepositoryService.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
                dataClientRepositoryService.delete
                a = a+1
            end                
            rescue => exception
                exception == 'Error'
        end
    end

    def data_client_delete(dataClientID)
        dataClientOdata = $DataClientServiceURi+"DataClients(#{dataClientID})?deletedBy=QATester"
        dataClientService = (RestServiceBase.new(dataClientOdata))
        dataClientService.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
        dataClientService.delete
    end

    def get_data_clients_body
        dataClientOdata = $DataClientServiceURi+"DataClients(#{$dataClient_ID})"
        dataClientRepositoryService = (RestServiceBase.new(dataClientOdata))
        dataClientRepositoryService.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
        return dataClientRepositoryService.get[:body]
    end

end