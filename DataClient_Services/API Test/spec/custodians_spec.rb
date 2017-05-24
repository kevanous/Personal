require_relative '../lib/includes'

describe "DataClient Custodians Service:" do
	before {
		$user_name = ENV['user']
		@elasticSearch = ElasticSearch.new
		@validations = Validations.new
		$sampleData = JSON.parse(SampleCustodiansFields::Insert_fields)
		$sampleData['CreatedBy'] = $user_name		
		$samplePatchData = JSON.parse(SamplePatchCustodianFields::Update_fields)
		@custodians = (RestServiceBase.new(DataClientService::Custodians))
		@custodians.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		}
	
	context "when a POST method is used to insert a new custodian entry" do
	
		it "then the new custodian entry created should have the same exact fields as the input data is inserted" do
			@start_time_post = Time.now.getutc.iso8601
			@response_post = @custodians.post($sampleData.to_json)
			@post_code = @response_post[:code]
			@post_body = JSON.parse(@response_post[:body])
			$newlyInserted_Id = @post_body["Id"]
			puts $newlyInserted_Id
			expect(@validations.ResponseCode_is_valid(@post_code)).to be true
			@validations.if_expect_fails_then_delete_record(@post_body, $sampleData, @post_code, $newlyInserted_Id)
			expect(@validations.custodian_Field_Validations(@post_body, $sampleData)).to be true
		end

		it "then a record of the custodian POST is created in elastic search" do
			sleep 1 #need sleep here otherwise the test is too fast to capture the logs
			@elasticSearch_custodians= (RestServiceBase.new(@elasticSearch.SingleResult("custodian", $newlyInserted_Id)))
			@elasticSearch_custodians.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body = @elasticSearch_custodians.get[:body]
			@elastic_parse = JSON.parse(@elastic_body)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["first_name"]).to eq (SingleCustodianField::FirstName)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["middle_name"]).to eq (SingleCustodianField::MiddleName)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["last_name"]).to eq (SingleCustodianField::LastName)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["display_name"]).to eq (SingleCustodianField::DisplayName)
			puts "The log of the custodian POST with ID #{$newlyInserted_Id} has been created in elastic search"
		end

		it "then a record of custodian POST in elastic search for DataClient showing the new DisplayName of the custodian is created" do
			@elasticSearch_dataClient = (RestServiceBase.new(@elasticSearch.SingleResult("data_client", SingleCustodianField::Data_ClientId)))
			@elasticSearch_dataClient.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body_dataClient = @elasticSearch_dataClient.get[:body]
			@elastic_dataClient_parse = JSON.parse(@elastic_body_dataClient)
			expect(@elastic_dataClient_parse["hits"]["hits"][0]["_source"]["custodian_display_names"]).to include (SingleCustodianField::DisplayName)
		end

		# it "pending example" do
		# 	skip("this is an example of pending test") do
		# 		expect(futureMethod).to be true
		# 	end
		# end
	end


	context "when a GET method is used to verify the result set" do
		before do
			@custodians_get_statusCode = @custodians.get[:code]
			@custodians_get_body = @custodians.get[:body]
		end

		it "then the result is a success code as well as the newly inserted data values are present" do
			expect(@custodians_get_statusCode).to eq (200)
			expect(@custodians_get_body).to include(SingleCustodianField::FirstName)
			expect(@custodians_get_body).to include(SingleCustodianField::MiddleName)
			expect(@custodians_get_body).to include(SingleCustodianField::LastName)
			expect(@custodians_get_body).to include(SingleCustodianField::DisplayName)
			puts "GET method outputs the newly inserted item's fields for the custodian"
		end

		it "then there are more logs of the custodians in elastic search" do
			sleep 1  #need sleep here otherwise the test is too fast to capture the logs
			@elasticSearch_custodians_FullList= (RestServiceBase.new(@elasticSearch.FullSet("custodian")))
			@elasticSearch_custodians_FullList.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body = @elasticSearch_custodians_FullList.get[:body]
			@elastic_parse = JSON.parse(@elastic_body)
			expect(@elastic_parse["hits"]["total"]).to be > 0
		end
	end


	context "when PATCH method is used to update a custodian entry" do
		it "then the updated row has the new custodian values" do
			@custodian_new = (RestServiceBase.new((DataClientService::Custodians)+"(#{$newlyInserted_Id})"))
			@custodian_new.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@custodian_new.patch(SamplePatchCustodianFields::Update_fields)
			@custodian_patch = (RestServiceBase.new((DataClientService::Custodians)+"(#{$newlyInserted_Id})"))
			@custodian_patch.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@patch_body = JSON.parse(@custodian_patch.get[:body])
			expect(@patch_body["DataClient"]).to eq $samplePatchData["DataClient"]
			expect(@patch_body["FirstName"]).to eq $samplePatchData["FirstName"]
			expect(@patch_body["MiddleName"]).to eq $samplePatchData["MiddleName"]
			expect(@patch_body["LastName"]).to eq $samplePatchData["LastName"]
			expect(@patch_body["DisplayName"]).to eq $samplePatchData["DisplayName"]
			puts "A PATCH method has been successfully implemented on the custodian Id #{$newlyInserted_Id}"
		end

		it "then the log of the custodian PATCH in elastic search is created" do
			sleep 1
			@elasticSearch_custodians= (RestServiceBase.new(@elasticSearch.SingleResult("custodian", $newlyInserted_Id)))
			@elasticSearch_custodians.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body = @elasticSearch_custodians.get[:body]
			@elastic_parse = JSON.parse(@elastic_body)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["data_client_id"]).to eq $samplePatchData["DataClientId"]
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["first_name"]).to eq $samplePatchData["FirstName"]
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["middle_name"]).to eq $samplePatchData["MiddleName"]
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["last_name"]).to eq $samplePatchData["LastName"]
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["display_name"]).to eq $samplePatchData["DisplayName"]
			puts "The log of the custodian PATCH with ID #{$newlyInserted_Id} has been created in elastic search"	
		end
	end


	context "when DELETE method is used to delete custodian row" do
		before do
			@custodian_delete = RestServiceBase.new((DataClientService::Custodians)+"(#{$newlyInserted_Id})?deletedBy=Kumar")
			@custodian_delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@custodian_delete.delete
		end

		it "then that record is deleted from the services" do
			deletedRow = RestServiceBase.new((DataClientService::Custodians)+"(#{$newlyInserted_Id})")
			deletedRow.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		 	deletedRow.get[:body]
		 	puts "As a clean up effort from the testing"
		 	puts "The whole entry for the new custodian Id #{$newlyInserted_Id} is Deleted" 
		 	expect(deletedRow.get[:body]).to eq "" # we would expect an empty string when no record exists
		end

		it "then that deletes the log of custodian from the custodian elastic search" do
			sleep 1
			@elasticSearch_custodians= (RestServiceBase.new(@elasticSearch.SingleResult("custodian", $newlyInserted_Id)))
			@elasticSearch_custodians.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body = @elasticSearch_custodians.get[:body]
			@elastic_parse = JSON.parse(@elastic_body)
			expect(@elastic_parse["hits"]["total"]).to eq 0
			expect(@elastic_parse["hits"]["hits"]).to eq []
		end

		it "then that deletes the log of the custodian from the data_client elastic search as well" do
			@elasticSearch_dataClient = (RestServiceBase.new(@elasticSearch.SingleResult("data_client", SingleCustodianField::Data_ClientId)))
			@elasticSearch_dataClient.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body_dataClient = @elasticSearch_dataClient.get[:body]
			@elastic_dataClient_parse = JSON.parse(@elastic_body_dataClient)
			expect(@elastic_dataClient_parse["hits"]["hits"][0]["_source"]["custodian_display_names"]).not_to include (SingleCustodianField::DisplayName)
		end
	end

end