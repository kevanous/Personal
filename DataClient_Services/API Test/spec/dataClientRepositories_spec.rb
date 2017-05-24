require_relative '../lib/includes'

describe "dataClientRepositories Services" do
	before {
		$sampleData = JSON.parse(SampleDCRFields::Insert_fields)
		$samplePatchData = JSON.parse(SamplePatchDCRFields::Update_fields)
		@dataClientRepositories = (RestServiceBase.new(DataClientService::DataClientRepositories))
		@dataClientRepositories.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		}
	
	context "when a POST method is used to insert a new DataClientRepositories entry" do
		before do
			@response_post = @dataClientRepositories.post(SampleDCRFields::Insert_fields)
			@post_body = JSON.parse(@response_post[:body])
			$newlyInserted_Id = @post_body["Id"]
			puts "The new DataClientRepository ID is #{$newlyInserted_Id}"
			@post_code = @response_post[:code]
			if @post_code == 201
			puts "Status code of #{@post_code} indicates The request has been fulfilled and resulted in a new resource being created"
			else
				"POST method not successful"
			end
		end
		it "then the new row should have the same DataClientRepository field values as the sample data" do
			#below comparing actual values in the database with the sample data
			expect(@post_code).to eq (201)
			expect(@post_body["DataClientId"]).to eq $sampleData["DataClientId"]
			expect(@post_body["RepositoryId"]).to eq $sampleData["RepositoryId"]
			expect(@post_body["MappingStatusId"]).to eq $sampleData["MappingStatusId"]
			expect(@post_body["CreatedBy"]).to eq $sampleData["CreatedBy"]
			expect(@post_body["UpdatedBy"]).to eq $sampleData["UpdatedBy"]
			puts "The inserted fields matches the sample data fields for the DataClientRepository Id #{$newlyInserted_Id}"
		end
	end

	context "when a GET method is used to verify the result set" do
		before do
			@dataClientRepositories_get_statusCode = @dataClientRepositories.get[:code]
			@dataClientRepositories_get_body = @dataClientRepositories.get[:body]
		end
		it "then the result should be success code as well as the newly inserted data values should be present" do
			expect(@dataClientRepositories_get_statusCode).to eq (200)
			expect(@dataClientRepositories_get_body).to include(SingleDCRFields::DataClientId)
			expect(@dataClientRepositories_get_body).to include(SingleDCRFields::RepositoryId)
			expect(@dataClientRepositories_get_body).to include(SingleDCRFields::MappingStatusId)
			expect(@dataClientRepositories_get_body).to include(SingleDCRFields::UpdatedBy)
			expect(@dataClientRepositories_get_body).to include(SingleDCRFields::UpdatedBy)
		end
	end

	context "when PATCH method is used to update a DataClientRepository entry" do
		before do
			@dataClientRepositories_new = (RestServiceBase.new((DataClientService::DataClientRepositories)+"(#{$newlyInserted_Id})"))
			@dataClientRepositories_new.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@dataClientRepositories_new.patch(SamplePatchDCRFields::Update_fields)
			@dataClientRepositories_patch = (RestServiceBase.new((DataClientService::DataClientRepositories)+"(#{$newlyInserted_Id})"))
			@dataClientRepositories_patch.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@patch_body = JSON.parse(@dataClientRepositories_patch.get[:body])
	 	end
		it "then the updated row should have the new dataClientRepository values" do
			expect(@patch_body["DataClientId"]).to eq $samplePatchData["DataClientId"]
			expect(@patch_body["RepositoryId"]).to eq $samplePatchData["RepositoryId"]
			expect(@patch_body["MappingStatusId"]).to eq $samplePatchData["MappingStatusId"]
			expect(@patch_body["UpdatedBy"]).to eq $samplePatchData["UpdatedBy"]
		end
	end

	context "when DELETE method is used to delete DataClientRepository row" do
		before do
			@dataClientRepository_delete = RestServiceBase.new((DataClientService::DataClientRepositories)+"(#{$newlyInserted_Id})?deletedBy=Kumar")
			@dataClientRepository_delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			byebug
			@dataClientRepository_delete.delete
		end
		it "then that record should be deleted from the services" do
			deletedRow = RestServiceBase.new((DataClientService::DataClientRepositories)+"(#{$newlyInserted_Id})")
			deletedRow.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		 	deletedRow.get[:body]
		 	puts "As a clean up effort from the testing"
		 	puts "The whole entry for the new DataClientRepository Id #{$newlyInserted_Id} is Deleted" 
		 	expect(deletedRow.get[:body]).to eq "" # we would expect an empty string when no record exists
		end
	end

end