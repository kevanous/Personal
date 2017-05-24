require_relative 'includes'

shared_context "API RestService and Setting Auth" do
	let(:allprojects) { allprojects = @api.RESTUriAndSetAuth(ProjectService::Projects)}
	let(:project_Active_Discovery) { project_Active_Discovery = @api.RESTUriAndSetAuth(ProjectService::Project_Active_Disc)}
	let(:project_Count_Active_Disc) { project_Count_Active_Disc = @api.RESTUriAndSetAuth(ProjectService::Project_Count_Active_Disc)}
	let(:project_OrderBy_Code) { project_OrderBy_Code = @api.RESTUriAndSetAuth(ProjectService::Project_OrderBy_Code)}
	let(:project_Expand_ClientID) { project_Expand_ClientID = @api.RESTUriAndSetAuth(ProjectService::Project_Expand_ClientID)}
	let (:allclients) {allclients = @api.RESTUriAndSetAuth(ProjectService::Clients)}
	let (:client_ID_GT100) {client_ID_GT100 = @api.RESTUriAndSetAuth(ProjectService::Clients_ID_GT1000)}
	let (:clients_Name_BillingName_Mismatch) { clients_Name_BillingName_Mismatch = @api.RESTUriAndSetAuth(ProjectService::Clients_Name_BillingName_Mismatch)}
	let (:clients_Name_NoExistant) { clients_Name_NoExistant = @api.RESTUriAndSetAuth(ProjectService::Clients_Name_NoExistant)}
	let (:client_Count_BillingNumber_notEqualNull) { client_Count_BillingNumber_notEqualNull = @api.RESTUriAndSetAuth(ProjectService::Client_Count_BillingNumber_notEqualNull)}
end

shared_context "ElasticSearch Uri and Set Auth" do
	let(:elastic_projectServices_uri) { elastic_projectServices_uri = @api.RESTUriAndSetAuth(@elasticSearch.logging_test(@start_time, "ProjectService Data Service"))}
end


