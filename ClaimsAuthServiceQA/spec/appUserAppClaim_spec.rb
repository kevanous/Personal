# require_relative '../lib/includes'

# RSpec.configure do |set_rest_config|
#   set_rest_config.before(:each) do
#     @claims_auth = ClaimsAuthService.new(ClaimsAuthUrls::SERVICES_URL, ConfigFile::ConfigFile_JSON)
#     @claims_auth.set_auth(UserInfo::DomainAdmin, UserInfo::AdminPassword)
#   end
# end

# describe 'Claims Auth services functionality for AppUserAppClaim entity' do
  
#   context 'making a GET request for AppUserAppClaim' do
#     before {
#       @get_call = @claims_auth.get('AppUserAppClaim')
#       byebug
#     }
#     it 'results in a success with 200 as response code and "OK" as response message' do
#       expect(@get_call[:code]).to eq 200
#       expect(@get_call[:response]).to eq 'OK'
#     end
#   end

#   context 'making a POST request for AppUserAppClaim' do
#     before {
#       byebug
#       @post_call = @claims_auth.post('AppUserAppClaim')
#       # $appUserAppClaim_id = JSON.parse(@post_call[:body])['Id']
#     }
#     it 'results in successful response for request and a new resouce is created' do
#       expect(@post_call[:code]).to eq 201
#       # Validating that the input body's property for the request is the same as the output property
#       expect(JSON.parse(@post_call[:body])['AppClaimId']).to eq JSON.parse(@post_call[:inputObject])['AppClaimId']
#     end
#   end

#   context 'making a PATCH request for AppUserAppClaim' do
#     before {
#       @patch_call = @claims_auth.patch('AppUserAppClaim')
#     }
#     it 'results in a successful update of the entity per the update(patch) body in the request' do
#       expect(@patch_call[:code]).to eq 200
#       # Validating that the input body's property for the request is the same as the output property
#       expect(JSON.parse(@patch_call[:body])['AppClaimId']).to eq JSON.parse(@patch_call[:inputObject])['AppClaimId']
#     end
#   end

#   context 'making a PUT request for AppUserAppClaim' do
#     before {
#       @put_call = @claims_auth.put('AppUserAppClaim')
#     }
#     it 'results in a successful update of the entity per the update(put) body in the request' do
#       expect(@put_call[:code]).to eq 200
#       # Validating that the input body's AppClaimId for the request is the same as the output AppClaimId
#       expect(JSON.parse(@put_call[:body])['AppClaimId']).to eq JSON.parse(@put_call[:inputObject])['AppClaimId']
#     end
#   end

#   context 'making a DELETE request for AppUserAppClaim' do
#     before {
#       @delete_call = @claims_auth.delete('AppUserAppClaim')
#       @input_object = JSON.parse(@delete_call[:inputObject])
#       @input_id = @input_object['Id'].to_s
#       @input_appClaimId = @input_object['AppClaimId']
#       @get_call = @claims_auth.get('AppUserAppClaim')
#     }
#     it 'results in the resource being deleted with 204 success code' do
#       expect(@delete_call[:code]).to eq 204
#       # Validating that the entity values set for delete did get deleted
#       expect(@get_call[:body]).not_to include @input_appClaimId
#     end
#   end
# end
