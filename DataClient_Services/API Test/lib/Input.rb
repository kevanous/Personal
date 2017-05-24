$DataClientServiceURi = 'http://mtpctscid304.consilio.com/DataClientService/v1/odata/'
$ProjectServiceURi = 'http://MTPCTSCID309.consilio.com/projectservice/v1/odata/'
# $ProjectServiceURi = 'https://test-mtp-projectservice.consilio.com/v1/odata/'
# $user_name = ENV['user']

module DataClientService
	SqlServer = 'MTPCTSCID302'
	Custodians = $DataClientServiceURi+'Custodians'
	CountCustodians = $DataClientServiceURi+"Custodians/$count"
	Repositories = $DataClientServiceURi+'Repositories'
	DataClients = $DataClientServiceURi+'DataClients'
	MappingStatuses = $DataClientServiceURi+'MappingStatuses'
	CustodianDisplayNameFormatTypeId = $DataClientServiceURi+'CustodianDisplayNameFormatTypeId'
	CustodianSegregationType = $DataClientServiceURi+'CustodianSegregationType'
	DataClientRepositories = $DataClientServiceURi+'DataClientRepositories'
	DataClientProjects = $DataClientServiceURi+'DataClientProjects'
	CustodianDisplayNameFormatType = $DataClientServiceURi+'CustodianDisplayNameFormatTypes'
	DataSegregationType = $DataClientServiceURi+'DataSegregationTypes'
end

module ProjectService
	Projects = $ProjectServiceURi+"Projects?$top=10"
	Project_Active_Disc = $ProjectServiceURi+"Projects?$select=ID,Name,DomainServiceLineName,DomainProjectStatusID &$filter=DomainServiceLineID+eq+1+and+DomainProjectStatusID+eq+1"
	# Project_Active_Disc = $ProjectServiceURi+"Projects?$top=10"
	Project_Count_Active_Disc = $ProjectServiceURi+"Projects/$count/?$filter=DomainServiceLineID+eq+1+and+DomainProjectStatusID+eq+1"
	Project_OrderBy_Code =  $ProjectServiceURi+"Projects/?$top=10&$select=ID, Code, ClientID, ClientName, Requestor, OleDbConnectionString, HasCertifiedContractTerms&$filter=DomainProjectStatusID eq 1 and HasCertifiedContractTerms eq true"
	Project_Expand_ClientID = $ProjectServiceURi+"Clients(0)?$expand=Projects"
	Project_Post = '{"Name": "QATest", "Code": "Q12345"}'
	Client_Post = '{"Name": "QATestClient", "BillingNumber": "A12345", "BililngName": "QATestClientBilling"}'
	Clients = $ProjectServiceURi+"Clients"
	Clients_ID_GT1000 =  $ProjectServiceURi+"Clients?$select=ID,Name,BillingNumber,BillingName&$filter=ID gt 1000"
	Clients_Name_BillingName_Mismatch = $ProjectServiceURi+"Clients?$select=ID,Name,BillingNumber,BillingName&$filter=Name ne BillingName"
	Clients_Name_NoExistant = $ProjectServiceURi+"Clients?$filter=Name eq 'QATester'"
	Client_Count_BillingNumber_notEqualNull = $ProjectServiceURi+"Clients/$count/?$filter=BillingNumber ne null"
end

module SingleCustodianField
	Data_ClientId = "3"
	FirstName = "Quality"
	MiddleName = "Assurance"
	LastName = "Tester"
	DisplayName = "Quality A Tester"
end

module SingleRepositoryField
	RepositoryTypeId = "1"
	CampusId = "1"
	DisplayName = "Tester1"
	HostName = "QA"
	StoreName = "Engineering$@"
	CreatedBy = "Tester"
	UpdatedBy = "Tester"
end

module SampleCustodiansFields
	Insert_fields = '{
		"DataClientId": 3,
		"FirstName": "Quality",
		"MiddleName": "Assurance",
		"LastName": "Tester",
		"DisplayName": "Quality A Tester",
		"CreatedBy": ""
		}'
end

module SamplePatchCustodianFields
	Update_fields = '{
		"DataClientId": 2,
		"FirstName": "UpdatedQuality",
		"MiddleName": "UpdatedAssurance",
	 	"LastName": "UpdatedTester",
	  	"DisplayName": "UpdatedQA Tester"
	  	}'
end

module SampleRepositoryFields
	Insert_fields = '{
		"RepositoryTypeId": 1,
		"CampusId": 1,
		"DisplayName": "Tester1",
		"HostName": "QA",
		"StoreName": "Engineering$@",
		"CreatedBy": "Tester",
		"UpdatedBy": "Tester"
		}'
end

module SamplePatchRepositoryFields
	Update_fields = '{
		"RepositoryTypeId": 1,
		"CampusId": 1,
		"DisplayName": "TesterUpdated",
		"HostName": "QAUpdated",
		"StoreName": "Engineering#$Updated",
		"CreatedBy": "Tester",
		"UpdatedBy": "TesterPatchUpdated"
		}'
end

module SampleDataClientFields
	Insert_fields = '{
		"Name": "DataClientTester",
		"DataSegregationTypeId": 1,
		"CustodianDisplayNameFormatTypeId": 1,
		"CustodianCustomAttributes": "{ \"custom_attribute_1\": \"default value\" }",
		"CreatedBy": "",
		"UpdatedBy": ""
		}'
end

module SamplePatchDataClientFields
	Update_fields = '{
		"Name": "DataClientTesterUpdated",
		"DataSegregationTypeId": 1,
		"CustodianDisplayNameFormatTypeId": 1,
		"CustodianCustomAttributes": "{ \"custom_attribute_1\": \"updated value\" }",
		"CreatedBy": "TesterUpdated",
		"UpdatedBy": "TesterUpdated"
		}'
end

module SingleDataClientFields
	Name = "DataClientTester"
	DataSegregationTypeId = 1
	CustodianDisplayNameFormatTypeId = 1
	CustodianCustomAttributes = '{"custom_attribute_1": "default value"}'
	CreatedBy = ENV['user']
	UpdatedBy = ENV['user']
end

module SampleMappingStatusFields
	Insert_fields =  '{
		"DisplayName": "QA Created",
		"Description": "Mapping was created by Testing process",
		"CreatedBy": "QATester",
		"UpdatedBy": "QATester"
		}'
end

module SamplePatchMappingStatusFields
	Update_fields = '{
		"DisplayName": "QA Created and Updated",
		"Description": "Mapping was created and then updated by Testing process",
		"UpdatedBy": "QATesterUpdated"
		}'
end

module SingleMappingStatus
	DisplayName = 'QA Created'
	Description = "Mapping was created by Testing process"
	CreatedBy = "QATester"
	UpdatedBy = "QATester"
end

module SampleDCRFields
	Insert_fields =   '{
		"DataClientId": 3,
		"RepositoryId": 3,
		"MappingStatusId": 1,
		"CreatedBy": "QA",
		"UpdatedBy": "QA"
		}'
end

module SamplePatchDCRFields
	Update_fields = '{
		"DataClientId": 3,
		"RepositoryId": 3,
		"MappingStatusId": 2,
		"UpdatedBy": "QA1"
		}'
end

module SingleDCRFields
	DataClientId = "3"
	RepositoryId = "3"
	MappingStatusId = "1"
	CreatedBy = "QA"
	UpdatedBy = "QA"
end

module Projects
	BusinessProjectId = '1121'
end

module MappingStatuses
	DisplayName = 'Engineering entered'
end

module CustodianDisplayNameFormatType
	DisplayName = 'First Middle Last'
end

module DataSegregationType
	Description = 'Client data repository stores must contain data ONLY for the data client. Client data repository hosts may contain stores for other data clients.'
end
