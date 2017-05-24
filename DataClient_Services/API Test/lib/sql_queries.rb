require 'tiny_tds'
require_relative 'includes'

def sqlCustodiansSelect
	client = TinyTds::Client.new dataserver:(DataClientService::SqlServer), database:'DataClient', username: @username, password: @password,timeout: 1000
	select_Custodians = "SELECT * FROM APP.Custodians" #change this to select only the fields that will be in the services
	select_custodians_result = client.execute(select_Custodians)

	select_custodians_result.each do |row|
		@custodianNames = row["Name"]
	end
	return @custodianNames
end


