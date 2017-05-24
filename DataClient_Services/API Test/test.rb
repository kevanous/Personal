# class Person
# 	def name
# 		@name
# 	end

# 	def name=(str)
#     @name = str
#   end
# end

# person = Person.new
# puts person.name
# person.name ="Dennis"
# puts person.name
require 'tiny_tds'
require 'json'
require 'awesome_print'

class SqlFunction
	# attr_accessor :client

	def SqlExec(query)
		client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'AdminDB', login_timeout: 5000, timeout: 5000
		result = client.execute(query)
		# client.close
		return result
	end

	def ProjectAll
		return self.SqlExec("SELECT TOP 10 * FROM ADMIN.vProject")
	# ap(result)
	# sql.client.close
	# sql.client.new
	end

	# result1 = self.new.SqlExec("SELECT ID, Name, DomainServiceLineName 
	# 			FROM ADMIN.vProject 
	# 			WHERE DomainProjectStatusID =1 
	# 			AND DomainServiceLineID = 1")
	# # ap(result1)
	# # sql.client.close

	# result2 = self.new.SqlExec("SELECT COUNT(*) AS [COUNT]
	# 			FROM ADMIN.vProject 
	# 			WHERE DomainServiceLineID = 1 
	# 			AND DomainProjectStatusID = 1")
	# # ap(result2)
	# # sql.client.close

	# result3= self.new.SqlExec("SELECT top 10 ID, Code,ClientID, ClientName, Requestor, OleDbConnectionString
	# 			FROM ADMIN.vProject
	# 			WHERE DomainProjectStatusID = 1
	# 			AND HasCertifiedContractTerms = 1
	# 			ORDER BY ID")
	# # ap(result3)
	# # sql.client.close
end

class StringConv

	def stringHashValue str
	  hash = 5381
	  str.each_byte do |b|
	  	hash = (((hash << 5) + hash) + b) % (2 ** 32)
  	end
  	hash
	end

	def checksum_value_sql(json_obj_sql, field)
		checksum = 0
		json_obj_sql.each do |row|
			string_name = row[field].to_s
			checksum = (checksum +self.stringHashValue(string_name)) % 100000
		end
		puts "The checksum value of field '#{field}' is #{checksum}"
		return checksum
	end
end

# class StringConversion
# 	def stringHashValue str
# 	  hash = 5381
# 	  str.each_byte do |b|
# 	  	hash = (((hash << 5) + hash) + b) % (2 ** 32)
#   	end
#   	hash
# 	end
# end 

# puts StringConv.new.checksum_value_sql(SqlFunction.new.ProjectAll, "Name")