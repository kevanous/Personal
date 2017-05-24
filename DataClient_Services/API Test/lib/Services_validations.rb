require 'spec_helper'
require_relative 'Input'

class Validations

	def custodian_Field_Validations(ins_obj, mock_obj)
		if (
			ins_obj["DataClientId"] == mock_obj["DataClientId"] and
			ins_obj["FirstName"] == mock_obj["FirstName"]	and
			ins_obj["MiddleName"] == mock_obj["MiddleName"]	and
			ins_obj["LastName"] == mock_obj["LastName"]	and
			ins_obj["DisplayName"] == mock_obj["DisplayName"] and
			ins_obj["CreatedBy"].include?(mock_obj["CreatedBy"])
			) 
			return true
		else
			return false
		end
	end

	def ResponseCode_is_valid(code)
		if code == 201
			puts "Status code of #{code} indicates the POST request has been fulfilled and resulted in a new resource being created"
			return true
		elsif code ==200
			puts "Status code of #{code} indicates the GET request was successful, an entity corresponding to the requested resource is sent in the response"
			return true
		elsif code == 501
			puts "Status code of #{code} indicates the POST request was not successful as it lacks the ability to fulfil the request"
			return true
		elsif code ==204
			puts "POST method not successful"
			return false
		else 
			return false
		end
	end

	def deleteRecord(uri)
		delete = RestServiceBase.new(uri)
		delete.set_auth(ENV['Test_UserName'], ENV['Test_Password'])
	  delete.delete
	end
	
	def if_expect_fails_then_delete_record(ins_obj, mock_obj, code, id)
		if self.custodian_Field_Validations(ins_obj, mock_obj) == true
			puts "A new entry for a custodian via POST method has been made successfully"
			puts "All the fields in DataClient Services matches the fields in mock entry data"
		else	
			uri = (DataClientService::Custodians)+"(#{id})?deletedBy=Kumar"
			self.deleteRecord(uri)
			puts "New insert custodian is deleted"
		end
	end
			
	def custodian_Elastic_Validations(elastic_obj, mock_obj)
		if compareObject?(elastic_obj, mock_obj)
			return true
		else
			return false
		end
	end

	def compareObject?(elastic_obj, mock_obj)
			(elastic_obj["hits"]["hits"][0]["_source"]["first_name"] == mock_obj["DataClientId"] and
			elastic_obj["hits"]["hits"][0]["_source"]["middle_name"] == mock_obj["FirstName"]	and
			elastic_obj["hits"]["hits"][0]["_source"]["last_name"] == mock_obj["MiddleName"]	and
			elastic_obj["hits"]["hits"][0]["_source"]["display_name"] == mock_obj["LastName"])
	end

end