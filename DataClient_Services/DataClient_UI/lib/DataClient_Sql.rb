require_relative 'includes'
# require 'tiny_tds'

class DataClient_SQL

    def SqlQuery(query)
		client = TinyTds::Client.new username: ENV['SQL_Login'], password: ENV['SQL_Password'], dataserver:'MLVUDPRJ01', database:'DataClient', login_timeout: 5000, timeout: 5000
		result = client.execute(query)
		return result
    end

    def DataClient_Name
        return self.SqlQuery(
            "SELECT * FROM App.DataClient")
		# "SELECT Name FROM App.DataClient WHERE NAME = 'DataClientDetails::DataClientName'")
    end

    def Custodian_Select

    end

    def DataClient_Delete
        return self.SqlQuery()
    end

end
