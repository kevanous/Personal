# rubocop:disable all

require_relative '../lib/includes'

describe "DataClient Services" do
	before {
		$user_name = ENV['user']
		@elasticSearch = ElasticSearch.new
		$sampleData = JSON.parse(SampleDataClientFields::Insert_fields)
		$sampleData['CreatedBy'] = $user_name
		$sampleData['UpdatedBy'] = $user_name	
		$samplePatchData = JSON.parse(SamplePatchDataClientFields::Update_fields)
		@dataClients = (RestServiceBase.new(DataClientService::DataClients))
		@dataClients.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		}
	
	context "when a POST method is used to insert a new dataClient entry" do
			
		it "then the new row created should have the same dataClient field values as the sample data" do
			#below comparing actual values in the database with the sample data
			@response_post = @dataClients.post($sampleData.to_json)
			@post_body = JSON.parse(@response_post[:body])
			$newlyInserted_Id = @post_body["Id"]
			puts "The new dataClient ID is #{$newlyInserted_Id}"
			@post_code = @response_post[:code]
			expect(@post_code).to eq (201)
			expect(@post_body["Name"]).to eq $sampleData["Name"]
			expect(@post_body["DataSegregationTypeId"]).to eq $sampleData["DataSegregationTypeId"]
			expect(@post_body["CustodianDisplayNameFormatTypeId"]).to eq $sampleData["CustodianDisplayNameFormatTypeId"]
			expect(@post_body["CustodianCustomAttributes"]).to eq $sampleData["CustodianCustomAttributes"]
			expect(@post_body["CreatedBy"]).to include $sampleData["CreatedBy"]
			expect(@post_body["UpdatedBy"]).to include $sampleData["UpdatedBy"]
			puts "The inserted fields matches the sample data fields for the dataClient Id #{$newlyInserted_Id}"
		end

		it "then the log of the dataClient POST is created in elastic search" do
			sleep 1 #need sleep here otherwise the test is too fast to capture the logs
			@elasticSearch_dataClient= (RestServiceBase.new(@elasticSearch.SingleResult("data_client", $newlyInserted_Id)))
			@elasticSearch_dataClient.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@elastic_body = @elasticSearch_dataClient.get[:body]
			@elastic_parse = JSON.parse(@elastic_body)
			puts @elastic_parse
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["name"]).to eq (SingleDataClientFields::Name)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["data_segregation_type_id"]).to eq (SingleDataClientFields::DataSegregationTypeId)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["custodian_display_name_format_type_id"]).to eq (SingleDataClientFields::CustodianDisplayNameFormatTypeId)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["custodian_custom_attributes"]).to eq JSON.parse(SingleDataClientFields::CustodianCustomAttributes)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["created_by"]).to include (SingleDataClientFields::CreatedBy)
			expect(@elastic_parse["hits"]["hits"][0]["_source"]["updated_by"]).to include (SingleDataClientFields::UpdatedBy)
			puts "The log of the custodian POST with ID #{$newlyInserted_Id} has been created in elastic search"
		end
	end

	context "when a GET method is used to verify the result set" do
		before do
			@dataClients_get_statusCode = @dataClients.get[:code]
			@dataClients_get_body = @dataClients.get[:body]
		end
		it "then the result should be success code as well as the newly inserted data values should be present" do
			expect(@dataClients_get_statusCode).to eq (200)
			expect(@dataClients_get_body).to include(SingleDataClientFields::Name)
			byebug
			expect(@dataClients_get_body).to include(SingleDataClientFields::DataSegregationTypeId)
			expect(@dataClients_get_body).to include(SingleDataClientFields::CustodianDisplayNameFormatTypeId)
			expect(@dataClients_get_body).to include(SingleDataClientFields::CustodianCustomAttributes)
			expect(@dataClients_get_body).to include(SingleDataClientFields::CreatedBy)
			expect(@dataClients_get_body).to include(SingleDataClientFields::UpdatedBy)
		end
	end

	context "when PATCH method is used to update a dataClient entry" do
		before do
			@dataClient_new = (RestServiceBase.new((DataClientService::DataClients)+"(#{$newlyInserted_Id})"))
			@dataClient_new.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@dataClient_new.patch(SamplePatchDataClientFields::Update_fields)
			@dataClient_patch = (RestServiceBase.new((DataClientService::DataClients)+"(#{$newlyInserted_Id})"))
			@dataClient_patch.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@patch_body = JSON.parse(@dataClient_patch.get[:body])
	 	end
		it "then the updated row should have the new dataClient values" do
			expect(@patch_body["Name"]).to eq $samplePatchData["Name"]
			expect(@patch_body["DataSegregationTypeId"]).to eq $samplePatchData["DataSegregationTypeId"]
			expect(@patch_body["CustodianDisplayNameFormatTypeId"]).to eq $samplePatchData["CustodianDisplayNameFormatTypeId"]
			expect(@patch_body["CustodianCustomAttributes"]).to eq $samplePatchData["CustodianCustomAttributes"]
			expect(@patch_body["CreatedBy"]).to include $sampleData["CreatedBy"]
			expect(@patch_body["UpdatedBy"]).to include $samplePatchData["UpdatedBy"]
		end
	end

	context "when DELETE method is used to delete dataClient row" do
		before do
			@dataClient_delete = RestServiceBase.new((DataClientService::DataClients)+"(#{$newlyInserted_Id})?deletedBy=Kumar")
			@dataClient_delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@dataClient_delete.delete
		end
		it "then that record should be deleted from the services" do
			deletedRow = RestServiceBase.new((DataClientService::DataClients)+"(#{$newlyInserted_Id})")
			deletedRow.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		 	deletedRow.get[:body]
		 	puts "As a clean up effort from the testing"
		 	puts "The whole entry for the new dataClient Id #{$newlyInserted_Id} is Deleted" 
		 	expect(deletedRow.get[:body]).to eq "" # we would expect an empty string when no record exists
		end
	end

end

# rubocop:enable all
