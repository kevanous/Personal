require_relative '../lib/includes'

describe "Project Services for Clients: Read Only--" do
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
			@clients_post = allclients.post(ProjectService::Client_Post)
			@pclients_post_statusCode = @clients_post[:code]
			expect(@pclients_post_statusCode).to eq (501)
		end
		
		it "then the status code of all clients will be 200 (Success)" do
			@client_all_get_statusCode = allclients.get[:code]
			expect(@validations.ResponseCode_is_valid(@client_all_get_statusCode)).to be true
		end

		it "then the status code of all clients with ID greater than 1000 will be 200 (Success)" do
			@client_ID_GT100_get_statusCode = client_ID_GT100.get[:code]
			expect(@validations.ResponseCode_is_valid(@client_ID_GT100_get_statusCode)).to be true
		end

		it "then the status code of all clients that have a mismatch between Billing Name and Client Name will be 200 (Success)" do
			@clients_Name_BillingName_Mismatch_get_statusCode = clients_Name_BillingName_Mismatch.get[:code]
			expect(@validations.ResponseCode_is_valid(@clients_Name_BillingName_Mismatch_get_statusCode)).to be true
		end

		it "then the status code of all clients that don't have a match will be 200 (Success)" do
			@clients_Name_NoExistant_get_statusCode = clients_Name_NoExistant.get[:code]
			expect(@validations.ResponseCode_is_valid(@clients_Name_NoExistant_get_statusCode)).to be true
		end

		it "then the status code of all of the resulting api call will be 200 (Success)" do
			@client_Count_BillingNumber_notEqualNull_get_statusCode = client_Count_BillingNumber_notEqualNull.get[:code]
			expect(@validations.ResponseCode_is_valid(@client_Count_BillingNumber_notEqualNull_get_statusCode)).to be true
		end

		it "then checksum of all clients with from services matches correspoinding checksum from sql database query" do
			@clientAll_parse = JSON.parse(allclients.get[:body])
			expect(@string.checksum_value_api(@clientAll_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.ClientSelectAll, "ID"))
		end

		it "then checksum of all clients with IDs greater than 1000 from services matches correspoinding checksum from sql database query" do
			@client_ID_GT100_parse = JSON.parse(client_ID_GT100.get[:body])
			expect(@string.checksum_value_api(@client_ID_GT100_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.Client_ID_GT1000, "ID"))
		end

	 	it "then checksum of all clients where the billing name and client name are differnt from services matches correspoinding checksum from sql database query" do
			@clients_Name_BillingName_Mismatch_parse = JSON.parse(clients_Name_BillingName_Mismatch.get[:body])
			expect(@string.checksum_value_api(@clients_Name_BillingName_Mismatch_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.ClientName_BillingName_Mismatch, "ID"))
		end

		it "then the result from services api call for non existant Name clients will be empty value and so will be from the sql database query" do
			@clients_Name_NoExistant_parse = JSON.parse(clients_Name_NoExistant.get[:body])
			expect(@string.checksum_value_api(@clients_Name_NoExistant_parse, "value", "ID")).to eq (@string.checksum_value_sql(@sql.ClientSearchEmpty, "ID"))
		end

		it "then the count of all clients where the BillingNumber is not equal to Null will be the same as from the sql database query" do
			@Client_Count_BillingNumber_NotEqualNull = client_Count_BillingNumber_notEqualNull.get[:body]
			expect(@Client_Count_BillingNumber_NotEqualNull.gsub(/[^0-9]/,'')).to eq (@string.checksum_COUNT_sql(@sql.Client_Count_BillingNumber_NotEqualNull, "COUNT"))
		end

	end

end
