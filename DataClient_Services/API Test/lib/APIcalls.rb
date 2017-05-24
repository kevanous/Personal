require_relative 'includes'	

class APICalls
	def RESTUriAndSetAuth(uri)
		rest_call = (RestServiceBase.new(uri))
		rest_call.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		return rest_call
	end
end