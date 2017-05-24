require_relative '../lib/includes'

describe "DataClient Projects, MappingStatuses, CustodianDisplayNameFormatType and DataSegregationType Services" do
	before :context do
		@username = ENV['Test_UserName']
		@password =  ENV['Test_Password']
	end

	context "When a get call is made on the custodians services" do
		before do
			@projects = RestServiceBase.new(DataClientService::DataClientProjects)
			@projects.set_auth(@username, @password)
			@projects_body = @projects.get[:body]
			@project_statusCode = @projects.get[:code]
		end

		it "should give us a success status code(200)and a body with at least sample custodian in the result" do
			expect(@project_statusCode).to eq (200)
			expect(@projects_body).to include(Projects::BusinessProjectId)
		end
	end

	context "When GET call is made on the mappingStatus" do
		before do
			@mappingStatuses = (RestServiceBase.new(DataClientService::MappingStatuses))
			@mappingStatuses.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@mappingStatuses_body = @mappingStatuses.get[:body]
			@mappingStatus_code = @mappingStatuses.get[:code]
		end

		it "should give us a success status code(200) and a body with at least sample custodian in the result" do
			expect(@mappingStatus_code).to eq (200)
			expect(@mappingStatuses_body).to include(MappingStatuses::DisplayName)
		end
	end

	context "When GET call is made on the CustodianDisplayNameFormatType" do
		before do
			@cusDisNameFormat = (RestServiceBase.new(DataClientService::CustodianDisplayNameFormatType))
			@cusDisNameFormat.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@cusDisNameFormat_body = @cusDisNameFormat.get[:body]
			@cusDisNameFormat_code = @cusDisNameFormat.get[:code]
		end

		it "should give us a success status code(200) and a body with at least sample custodian in the result" do
			expect(@cusDisNameFormat_code).to eq (200)
			expect(@cusDisNameFormat_body).to include(CustodianDisplayNameFormatType::DisplayName)
		end
	end

	context "When GET call is made on the DataSegregationType" do
		before do
			@dataSegType = (RestServiceBase.new(DataClientService::DataSegregationType))
			@dataSegType.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@dataSegType_body = @dataSegType.get[:body]
			@dataSegType_code = @dataSegType.get[:code]
		end

		it "should give us a success status code(200) and a body with at least sample custodian in the result" do
			expect(@dataSegType_code).to eq (200)
			expect(@dataSegType_body).to include(DataSegregationType::Description)
		end
	end
end
