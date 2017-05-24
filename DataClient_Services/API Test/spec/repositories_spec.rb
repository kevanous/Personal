require_relative '../lib/includes'

describe "DataClient Repositories Services" do
	before {
		$sampleData = JSON.parse(SampleRepositoryFields::Insert_fields)
		$samplePatchData = JSON.parse(SamplePatchRepositoryFields::Update_fields)
		@repositories = RestServiceBase.new(DataClientService::Repositories)
		@repositories.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		}

	context "when a POST method is made to insert a Repository info into Data Client" do
		before do
			@response_post = @repositories.post(SampleRepositoryFields::Insert_fields)
			@post_body = JSON.parse(@response_post[:body])
			$newlyInserted_Id = @post_body["Id"]
			puts "The new repository ID is #{$newlyInserted_Id}"
			@post_code = @response_post[:code]
			if @post_code == 201
			puts "Status code of #{@post_code} indicates The request has been fulfilled and resulted in a new resource being created"
			else
				"POST method not successful"
			end
		end
		it "then the new row should have the same repository field values as the sample data" do
			#below comparing actual values in the database with the sample data
			expect(@post_code).to eq (201)
			expect(@post_body["RepositoryTypeId"]).to eq $sampleData["RepositoryTypeId"]
			expect(@post_body["CampusId"]).to eq $sampleData["CampusId"]
			expect(@post_body["DisplayName"]).to eq $sampleData["DisplayName"]
			expect(@post_body["HostName"]).to eq $sampleData["HostName"]
			expect(@post_body["StoreName"]).to eq $sampleData["StoreName"]
			expect(@post_body["CreatedBy"]).to eq $sampleData["CreatedBy"]
			expect(@post_body["UpdatedBy"]).to eq $sampleData["UpdatedBy"]			
			puts "The inserted fields matches the sample data fields for the repository Id #{$newlyInserted_Id}"
		end
	end

	context "when a GET method is used to verifty the result set" do
		before do
			@repository_GET_status_code = @repositories.get[:code]
			@repository_get_body = @repositories.get[:body]
		end
		it "should give us a success status code (200) and also a body with at least sample repository in the result" do
			expect(@repository_GET_status_code).to eq (200)
			expect(@repository_get_body).to include(SingleRepositoryField::RepositoryTypeId)
			expect(@repository_get_body).to include(SingleRepositoryField::CampusId)
			expect(@repository_get_body).to include(SingleRepositoryField::DisplayName)
			expect(@repository_get_body).to include(SingleRepositoryField::HostName)
			expect(@repository_get_body).to include(SingleRepositoryField::StoreName)
			expect(@repository_get_body).to include(SingleRepositoryField::CreatedBy)
			expect(@repository_get_body).to include(SingleRepositoryField::UpdatedBy)
		end
	end

	context "when a PATCH method is used to update an entry" do
		before do
			@repository_new = (RestServiceBase.new((DataClientService::Repositories)+"(#{$newlyInserted_Id})"))
			@repository_new.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@repository_new.patch(SamplePatchRepositoryFields::Update_fields)
			@repository_patch = (RestServiceBase.new((DataClientService::Repositories)+"(#{$newlyInserted_Id})"))
			@repository_patch.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			@patch_body = JSON.parse(@repository_patch.get[:body])
		end
		it "then the updated row should have the new repository values" do
			expect(@patch_body["RepositoryTypeId"]).to eq $samplePatchData["RepositoryTypeId"]
			expect(@patch_body["CampusId"]).to eq $samplePatchData["CampusId"]
			expect(@patch_body["DisplayName"]).to eq $samplePatchData["DisplayName"]
			expect(@patch_body["HostName"]).to eq $samplePatchData["HostName"]
			expect(@patch_body["StoreName"]).to eq $samplePatchData["StoreName"]
			expect(@patch_body["CreatedBy"]).to eq $samplePatchData["CreatedBy"]
			expect(@patch_body["UpdatedBy"]).to eq $samplePatchData["UpdatedBy"]
		end
	end

	context "when DELETE method is used to delete repository row" do
		before do
			@repository_delete = RestServiceBase.new((DataClientService::Repositories)+"(#{$newlyInserted_Id})?deletedBy=Kumar")
			@repository_delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
			byebug
			@repository_delete.delete
		end
		it "then that record should be deleted from the services" do
			deletedRow = RestServiceBase.new((DataClientService::Repositories)+"(#{$newlyInserted_Id})")
			deletedRow.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		 	deletedRow.get[:body]
		 	puts "As a clean up effort from the testing"
		 	puts "The whole entry for the new repository Id #{$newlyInserted_Id} is Deleted" 
		 	expect(deletedRow.get[:body]).to eq "" # we would expect an empty string when no record exists
		end
	end

end


