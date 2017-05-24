class StringConversion
	def stringHashValue str
	  hash = 5381
	  str.each_byte do |b|
	  	hash = (((hash << 5) + hash) + b) % (2 ** 32)
  	end
  	hash
	end

	def checksum_value_api(json_obj_api, json_title, field)
		checksum = 0
		json_obj_api[json_title].each do |row|
			string_name = row[field].to_s
			checksum = (checksum +self.stringHashValue(string_name)) % 100000
		end
		return checksum
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

	def checksum_COUNT_sql(json_obj_sql, field)
		json_obj_sql.each do |row|
			@string_name = row[field].to_s
		end
		return @string_name
	end

	def sql_fields(json_obj_sql, field)
		json_obj_sql.each do |row|
			return row
		end
	end

end

	
