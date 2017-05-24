require 'tiny_tds'
require 'byebug'

		# byebug
		client = TinyTds::Client.new(:dataserver=>'localhost', :database=>'AdminDB')
		byebug
		puts result = client.execute("SELECT  TOP 10 * FROM ADMIN.vProject")


