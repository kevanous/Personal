require_relative '../lib/includes'

RSpec.configure do |set_rest_config|
  set_rest_config.before(:each) do
    @claims_auth = ClaimsAuthService.new(ClaimsAuthUrls::SERVICES_URL, ConfigFile::ConfigFile_JSON)
    @claims_auth.set_auth(UserInfo::DomainAdmin, UserInfo::AdminPassword)
    @claims_auth.set_log_filepath('ClaimsAutLog.txt')
  end
end

describe 'Claims Auth services functionality for Activity entity' do

  context 'making a GET request for Activity' do
    before {
      @get_call = @claims_auth.get('Activity')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a POST request for Activity' do
    before {
      @post_call = @claims_auth.post('Activity')
      $activity_id = JSON.parse(@post_call[:body])['Id']
    }
    it 'results in successful response for request and a new resouce is created' do
      expect(@post_call[:code]).to eq 201
      # Validating that the input body's property for the request is the same as the output property
      expect(JSON.parse(@post_call[:body])['Name']).to eq JSON.parse(@post_call[:inputObject])['Name']
      expect(JSON.parse(@post_call[:body])['Resource']).to eq JSON.parse(@post_call[:inputObject])['Resource']
      expect(JSON.parse(@post_call[:body])['Operation']).to eq JSON.parse(@post_call[:inputObject])['Operation']
    end
  end

  context 'making a PATCH request for Activity' do
    before {
      @patch_call = @claims_auth.patch('Activity')
    }
    it 'results in a successful update of the entity per the update(patch) body in the request' do
      expect(@patch_call[:code]).to eq 200
      # Validating that the input body's property for the request is the same as the output property
      expect(JSON.parse(@patch_call[:body])['Name']).to eq JSON.parse(@patch_call[:inputObject])['Name']
      expect(JSON.parse(@patch_call[:body])['Resource']).to eq JSON.parse(@patch_call[:inputObject])['Resource']
      expect(JSON.parse(@patch_call[:body])['Operation']).to eq JSON.parse(@patch_call[:inputObject])['Operation']
    end
  end

  context 'making a PUT request for Activity' do
    before {
      @put_call = @claims_auth.put('Activity')
    }
    it 'results in a successful update of the entity per the update(put) body in the request' do
      expect(@put_call[:code]).to eq 200
      # Validating that the input body's Name for the request is the same as the output Name
      expect(JSON.parse(@put_call[:body])['Name']).to eq JSON.parse(@put_call[:inputObject])['Name']
      expect(JSON.parse(@put_call[:body])['Resource']).to eq JSON.parse(@put_call[:inputObject])['Resource']
      expect(JSON.parse(@put_call[:body])['Operation']).to eq JSON.parse(@put_call[:inputObject])['Operation']
    end
  end

  context 'making a DELETE request for Activity' do
    before {
      @delete_call = @claims_auth.delete('Activity')
      @input_object = JSON.parse(@delete_call[:inputObject])
      @input_id = @input_object['Id'].to_s
      @input_name = @input_object['Name']
      @input_resource = @input_object['Resource']
      @input_operation = @input_object['Operation']
      @get_call = @claims_auth.get('Activity')
    }
    it 'results in the resource being deleted with 204 success code' do
      expect(@delete_call[:code]).to eq 204
      # Validating that the entity values set for delete did not get deleted
      expect(@get_call[:body]).not_to include @input_name
      expect(@get_call[:body]).not_to include @input_resource
      expect(@get_call[:body]).not_to include @input_operation
    end
  end
end
