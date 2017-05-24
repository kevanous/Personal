require_relative '../lib/includes'

describe 'Project Services for Projects: Read Only--' do
	before {
	@elasticSearch = ElasticSearch.new
		@validations = Validations.new
		@sql = SqlProjectService.new
		@api = APICalls.new
		@string = StringConversion.new
	}

	include_context "API RestService and Setting Auth"
	
	context "when a GET/POST method is used to verify the result set" do
	
		it "then the post method results in 501 error code indicating that this method is not implemented" do
			start_time_post = Time.now.getutc.iso8601	
			@projects_post = allprojects.post(ProjectService::Project_Post)
			@projects_post_statusCode = @projects_post[:code]
			expect(@projects_post_statusCode).to eq (501)
			expect(@elasticSearch.getElasticResponseValue(start_time_post, "ResponseStatusCode")).to eq (@projects_post_statusCode)
		end

		it "then the status code of all active projects in discovery will be 200 (Success)" do
			start_time_get = Time.now.getutc.iso8601
			prjActiveDisc_get_statusCode = project_Active_Discovery.get[:code]
			expect(@validations.ResponseCode_is_valid(prjActiveDisc_get_statusCode)).to be true
			expect(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseStatusCode")).to eq (prjActiveDisc_get_statusCode)
		end

		it "then the status code of count of all active projects in discovery will be 200 (Success)" do
			start_time_get = Time.now.getutc.iso8601
			prjCountActiveDisc_get_statusCode = project_Count_Active_Disc.get[:code]
			expect(@validations.ResponseCode_is_valid(prjCountActiveDisc_get_statusCode)).to be true
			expect(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseStatusCode")).to eq (prjCountActiveDisc_get_statusCode)
		end

		it "then the status code of all active projects with Certified Contract Terms will be 200 (Success)" do
			start_time_get = Time.now.getutc.iso8601
			prjOrderByCode_get_statusCode = project_OrderBy_Code.get[:code]
			expect(@validations.ResponseCode_is_valid(prjOrderByCode_get_statusCode)).to be true
			expect(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseStatusCode")).to eq (prjOrderByCode_get_statusCode)
		end

		it "then the status code of expand GET call will be 200 (Success)" do
			start_time_get = Time.now.getutc.iso8601
			prjExpandClientID_get_statusCode = project_Expand_ClientID.get[:code]
			expect(@validations.ResponseCode_is_valid(prjExpandClientID_get_statusCode)).to be true
			expect(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseStatusCode")).to eq (prjExpandClientID_get_statusCode)
		end

		it "then the checksum of all project IDs from services matches the corresponding value from sql query" do
			start_time_get = Time.now.getutc.iso8601
			prjAll_parse = JSON.parse(allprojects.get[:body])
			expect(@string.checksum_value_api(prjAll_parse, "value", "Code")).to eq (@string.checksum_value_sql(@sql.ProjectSelectAll, "Code"))
			expect(prjAll_parse["value"][1]["ID"]).to eq JSON.parse(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseContentBody"))["value"][1]["ID"]
		end

		it "then the JSON object of the sql result for all projects with selected fields that are active and in discovery matches with its corresponding GET REST call " do
			start_time_get = Time.now.getutc.iso8601
			prjActiveDisc_parse = JSON.parse(project_Active_Discovery.get[:body])
			expect(@string.checksum_value_api(prjActiveDisc_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.Project_Active_Discovery, "ID"))
			expect(prjActiveDisc_parse["value"][1]["ID"]).to eq JSON.parse(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseContentBody"))["value"][1]["ID"]
		end

		it "then the JSON object of the sql result for the COUNT of all projects that are active and in discovery matches with its corresponding GET REST call " do
			start_time_get = Time.now.getutc.iso8601
			prjCountActiveDisc = project_Count_Active_Disc.get[:body]
			expect(prjCountActiveDisc.gsub(/[^0-9]/,'')).to eq (@string.checksum_COUNT_sql(@sql.Project_Count_Active_Discovery, "COUNT"))
			expect(prjCountActiveDisc.gsub(/[^0-9]/,'')).to eq (@elasticSearch.getElasticResponseValue(start_time_get, "ResponseContentBody"))
		end

		it "then the JSON object of the sql result for all projects with selected fields that are active and which has contract terms matches ordered by CODE with its corresponding GET REST call " do
			start_time_get = Time.now.getutc.iso8601
			prjOrderByCode_parse = JSON.parse(project_OrderBy_Code.get[:body])
			expect(@string.checksum_value_api(prjOrderByCode_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.Project_OrderBy_Code, "ID"))
			expect(prjOrderByCode_parse["value"][1]["ID"]).to eq JSON.parse(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseContentBody"))["value"][1]["ID"]
		end

		it "then the JSON object of the sql result for all projects inner joined to Client via ClientID matches with the corrrespondingGET REST call" do
			start_time_get = Time.now.getutc.iso8601
			prjExpandClientID_parse = JSON.parse(project_Expand_ClientID.get[:body])
			expect(@string.checksum_value_api(prjExpandClientID_parse, "Projects", "ID")).to eq (@string.checksum_value_sql(@sql.Project_Expand_ClientID, "ID"))
			expect(prjExpandClientID_parse["ID"]).to eq JSON.parse(@elasticSearch.getElasticResponseValue(start_time_get, "ResponseContentBody"))["ID"]
		end
	end
end
