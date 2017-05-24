require_relative '../lib/includes'

describe 'Claims Auth services functionality for App entity' do

  context 'making a GET request for app' do
    before {
      @get_call = @claims_auth.get('App')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a GET request for app by second user' do
    before {
      @get_call = @claims_auth_user2.get('App')
    }
    it 'results in a success with 200 as response code and "OK" as response message' do
      expect(@get_call[:code]).to eq 200
      expect(@get_call[:response]).to eq 'OK'
    end
  end

  context 'making a POST request for apps' do
    before {
      @post_call = @claims_auth.post('App')
      $post_body = @post_call[:inputObject]
      $app_name = JSON.parse(@post_call[:body])['Name']
    }
    it 'results in successful response for request and a new resource is created' do
      expect(@post_call[:code]).to eq 201
      # Validating that the input body's property for the request is the same as the output property
      expect($app_name).to eq JSON.parse($post_body)['Name']
    end

    it 'with a different user has no access to the entitity created' do
      @get_call = @claims_auth_user2.get('App')
      expect(@get_call[:body]).not_to include $app_name 
    end
  end

  context 'making a second POST with the already posted input value' do
    before {
      @second_post_call = @claims_auth.manual_post('/Apps', $post_body)
    }
    it 'results in error due to the duplicate record collision' do
      expect(@second_post_call[:code]).to eq 409
    end
  end

  context 'making a PATCH request for app' do
    before {
      @patch_call = @claims_auth.patch('App')
    }
    it 'results in a successful update of the entity per the update(patch) body in the request' do
      expect(@patch_call[:code]).to eq 200
      # Validating that the input body's property for the request is the same as the output property
      expect(JSON.parse(@patch_call[:body])['Name']).to eq JSON.parse(@patch_call[:inputObject])['Name']
    end
  end

  context 'making a PUT request for app' do
    before {
      @put_call = @claims_auth.put('App')
    }
    it 'results in a successful update of the entity per the update(put) body in the request' do
      expect(@put_call[:code]).to eq 200
      # Validating that the input body's Name for the request is the same as the output Name
      expect(JSON.parse(@put_call[:body])['Name']).to eq JSON.parse(@put_call[:inputObject])['Name']
    end
  end

  context 'making a DELETE request for app' do
    before {
      @delete_call = @claims_auth.delete('App')
      @input_object = JSON.parse(@delete_call[:inputObject])
      @input_id = @input_object['Id'].to_s
      @input_name = @input_object['Name']
    }
    it 'results in an error since it is not allowed in the current context' do
      expect(@delete_call[:code]).to eq 501
      # Validating that the entity values set for delete did not get deleted
      expect(JSON.parse(@delete_call[:inputObject])['Name']).to include @input_name
    end
  end
end
