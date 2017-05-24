require 'RestServiceBase'
require 'json'


#give me all logs between current_time and endtime and username = "kshrestha\consilio"(try grabbing this dynamically, ie without usinig env variable hardcoded)
			
		start_time = Time.now.iso8601	
		elastic_url = "http://mtpvpseslg02.consilio.com:9200/logging_test/_search?q=origin_timestamp:[#{start_time}+TO+now]&pretty&size=10&sort=origin_timestamp:desc"
		rest_call = (RestServiceBase.new(elastic_url))
		rest_call.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
		@elastic_body = rest_call.get[:body]
	 	@elastic_parse = JSON.parse(@elastic_body)
		response_body=  JSON.parse(@elastic_parse["hits"]["hits"][0]["_source"]["extended_properties"]["project_service_data_service"]["action_request_response-debug"]["ResponseContentBody"])
		puts response_body["ID"]		
		puts "start_time = #{start_time}"
	