require_relative 'includes' 

class ElasticSearch
	
	def ElasticSearchUri
		return "http://mtpvpseslg01:9200"
	end

	def SingleResult(index, id)
		return self.ElasticSearchUri+"/data_client_test/#{index}/_search?pretty=true&q=_id:#{id}"
	end

	def FullSet(index)
		return self.ElasticSearchUri+"/data_client_test/#{index}/_search?pretty=true"
	end

	def logging_test(time_stamp, app_name, event_name)
		return self.ElasticSearchUri+"/logging_test/_search?q=app_name:#{app_name} AND origin_timestamp:[#{time_stamp}+TO+now] AND event_name:#{event_name}&sort=origin_timestamp:desc&pretty"
	end

	def elastic_response_logValue(json_obj, property)
		return json_obj["hits"]["hits"][0]["_source"]["extended_properties"]["project_service_data_service"]["action_request_response-debug"][property]
	end
 	
 	def getElasticProjectUri(start_time)
 		return APICalls.new.RESTUriAndSetAuth(self.logging_test(start_time, "ProjectService Data Service", "ActionRequestResponse-Debug"))
 	end

	def getElasticResponseValue(start_time, property)
		sleep 2
		begin
			counter = 1
			while true
				@elastic_parse = JSON.parse(self.getElasticProjectUri(start_time).get[:body])
				counter += 1
				if counter == 60 || @elastic_parse["hits"]["total"] != 0
					if counter == 60
						puts "elastic search didnt find any relevant logs, waited for 1 minute"
					end
					break
				end
				sleep 1
				puts "loop = #{counter}"
			end
			puts "Number of elastic search hits = #{@elastic_parse["hits"]["total"]}"
			return elastic_responseCode = self.elastic_response_logValue(@elastic_parse, property)
			# rescue => exception
			# 	puts @elastic_parse
			# 	puts exception.backtrace
			# 	puts "Error occured"
		end
	end
	
	def wait(time, increment = 5, elapsed_time = 0, &block)
  	begin
   	 yield
 		rescue Exception => e
    	if elapsed_time >= time
      	raise e
    	else
      	sleep increment
      wait(time, increment, elapsed_time + increment, &block)
    	end
  	end
	end

  # def custodianElasticCompare(json_obj)
  # 		(@elastic_parse["hits"]["hits"][0]["_source"]["first_name"]).to eq (SingleCustodianField::FirstName)
		# 	(@elastic_parse["hits"]["hits"][0]["_source"]["middle_name"]).to eq (SingleCustodianField::MiddleName)
		# 	(@elastic_parse["hits"]["hits"][0]["_source"]["last_name"]).to eq (SingleCustodianField::LastName)
		# 	(@elastic_parse["hits"]["hits"][0]["_source"]["display_name"]).to eq (SingleCustodianField::DisplayName)


  # end
end
