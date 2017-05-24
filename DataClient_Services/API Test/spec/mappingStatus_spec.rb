require_relative '../lib/includes'

describe "DataClient MappingStatus Services" do
	before {
		$sampleData = JSON.parse(SampleMappingStatusFields::Insert_fields)
		$samplePatchData = JSON.parse(SamplePatchMappingStatusFields::Update_fields)
		@mappingStatuses = (RestServiceBase.new(DataClientService::MappingStatuses))
		@mappingStatuses.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		}
	
	context "when a POST method is used to insert a new mappingStatus entry" do
		before do
			@response_post = @mappingStatuses.post(SampleMappingStatusFields::Insert_fields)
			@post_body = JSON.parse(@response_post[:body])
			$newlyInserted_Id = @post_body["Id"]
			puts "The new mappingStatus ID is #{$newlyInserted_Id}"
			@post_code = @response_post[:code]
			if @post_code == 201
			puts "Status code of #{@post_code} indicates The request has been fulfilled and resulted in a new resource being created"
			else
				"POST method not successful"
			end
		end
		it "then the new row should have the same mappingStatus field values as the sample data" do
			#below comparing actual values in the database with the sample data
			expect(@post_code).to eq (201)
			expect(@post_body["DisplayName"]).to eq $sampleData["DisplayName"]
			expect(@post_body["Description"]).to eq $sampleData["Description"]
			expect(@patch_body["CreatedBy"]).to eq $sampleData["CreatedBy"]
			expect(@post_body["UpdatedBy"]).to eq $sampleData["UpdatedBy"]
			puts "The inserted fields matches the sample data fields for the mappingStatus Id #{$newlyInserted_Id}"
		end
	end

	context "when a GET method is used to verify the result set" do
		before do
			@mappingStatuses_get_statusCode = @mappingStatuses.get[:code]
			@mappingStatuses_get_body = @mappingStatuses.get[:body]
		end
		it "then the result should be success code as well as the newly inserted data values should be present" do
			expect(@mappingStatuses_get_statusCode).to eq (200)
			expect(@mappingStatuses_get_body).to include(SingleMappingStatus::DisplayName)
			expect(@mappingStatuses_get_body).to include(SingleMappingStatus::Description)
			expect(@mappingStatuses_get_body).to include(SingleMappingStatus::CreatedBy)
			expect(@mappingStatuses_get_body).to include(SingleMappingStatus::UpdatedBy)
		end
	end

	context "when PATCH method is used to update a mappingStatus entry" do
		before do
			@mappingStatus_new = (RestServiceBase.new((DataClientService::MappingStatuses)+"(#{$newlyInserted_Id})"))
			@mappingStatus_new.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@mappingStatus_new.patch(SamplePatchMappingStatusFields::Update_fields)
			@mappingStatus_patch = (RestServiceBase.new((DataClientService::MappingStatuses)+"(#{$newlyInserted_Id})"))
			@mappingStatus_patch.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@patch_body = JSON.parse(@mappingStatus_patch.get[:body])
	 	end
		it "then the updated row should have the new mappingStatus values" do
			expect(@patch_body["DisplayName"]).to eq $samplePatchData["DisplayName"]
			expect(@patch_body["Description"]).to eq $samplePatchData["Description"]
			expect(@patch_body["UpdatedBy"]).to eq $samplePatchData["UpdatedBy"]
			expect(@patch_body["CreatedBy"]).to eq $sampleData["CreatedBy"]
		end
	end

	context "when DELETE method is used to delete mappingStatus row" do
		before do
			@mappingStatus_delete = RestServiceBase.new((DataClientService::MappingStatuses)+"(#{$newlyInserted_Id})?deletedBy=Kumar")
			@mappingStatus_delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@mappingStatus_delete.delete
		end
		it "then that record should be deleted from the services" do
			deletedRow = RestServiceBase.new((DataClientService::MappingStatuses)+"(#{$newlyInserted_Id})")
			deletedRow.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		 	deletedRow.get[:body]
		 	puts "As a clean up effort from the testing"
		 	puts "The whole entry for the new mappingStatus Id #{$newlyInserted_Id} is Deleted" 
		 	expect(deletedRow.get[:body]).to eq "" # we would expect an empty string when no record exists
		end
	end

end