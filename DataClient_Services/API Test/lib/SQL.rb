require 'includes'

class SqlProjectService
	
	def SqlQuery(query)
		client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'AdminDB', login_timeout: 5000, timeout: 5000
		result = client.execute(query)
		return result
	end

	def ProjectSelectAll
		return self.SqlQuery(
		"SELECT  TOP 10 * FROM ADMIN.vProject")
	end

	def ProjectSelectAllRow
		return self.SqlQueryWRow(
		"SELECT  TOP 10 * FROM ADMIN.vProject")
	end

	def Project_Active_Discovery
		return self.SqlQuery(
		"SELECT ID, Name, DomainServiceLineName 
			FROM ADMIN.vProject 
			WHERE DomainProjectStatusID =1 
			AND DomainServiceLineID = 1"
		)
	end

	def Project_Count_Active_Discovery
		return self.SqlQuery(
		"SELECT COUNT(*) AS [COUNT]
			FROM ADMIN.vProject 
			WHERE DomainServiceLineID = 1 
			AND DomainProjectStatusID = 1"
		)
	end

	def Project_OrderBy_Code
		return self.SqlQuery(
		"SELECT top 10 ID, Code,ClientID, ClientName, Requestor, OleDbConnectionString
			FROM ADMIN.vProject
			WHERE DomainProjectStatusID = 1
			AND HasCertifiedContractTerms = 1
			ORDER BY ID"
		)
	end

	def Project_Expand_ClientID
		return self.SqlQuery(
		"SELECT * FROM ADMIN.vClient VC
			INNER JOIN ADMIN.vProject VP
			ON VP.ClientID = VC.ID
			WHERE VC.ID = 0"
		)
	end

	def ClientSelectAll
		return self.SqlQuery(
		"SELECT * FROM ADMIN.vClient")
	end

	def Client_ID_GT1000
		return self.SqlQuery(
		"SELECT ID, Name, BillingNumber 
			FROM ADMIN.vClient 
			WHERE ID>1000"
		)
	end

	def ClientName_BillingName_Mismatch
		return self.SqlQuery(
		"SELECT ID, Name, BillingNumber, BillingName
			FROM ADMIN.vClient
			WHERE ISNULL(Name, '')<> ISNULL(BillingName, '')"
			)
	end

	def ClientSearchEmpty
		return self.SqlQuery(
		"SELECT * FROM ADMIN.vClient 
			WHERE NAME = 'QA TESTER'"
			)
	end

	def Client_Count_BillingNumber_NotEqualNull
		return self.SqlQuery(
			"SELECT COUNT(*) AS [COUNT]FROM ADMIN.vClient
			WHERE BillingNumber IS NOT NULL"
			)
	end

end


# module SqlQueries
# 	ProjectSelectAll =			"SELECT  TOP 10 * FROM ADMIN.vProject"
# 	Project_Active_Discovery =     "SELECT ID, Name, DomainServiceLineName FROM ADMIN.vProject WHERE DomainProjectStatusID =1 AND DomainServiceLineID = 1"
# 	Project_Count_Active_Discovery =         "SELECT COUNT(*) AS [COUNT]    FROM ADMIN.vProject WHERE DomainServiceLineID = 1 AND DomainProjectStatusID = 1"
# 	Project_OrderBy_Code =    "SELECT top 10 ID, Code,ClientID, ClientName, Requestor, OleDbConnectionString FROM ADMIN.vProject WHERE DomainProjectStatusID = 1 AND HasCertifiedContractTerms = 1 ORDER BY ID"
# 	Project_Expand_ClientID =    "SELECT * FROM ADMIN.vClient VC    INNER JOIN ADMIN.vProject VP ON VP.ClientID = VC.ID    WHERE VC.ID = 0"
# 	ClientSelectAll =        "SELECT * FROM ADMIN.vClient"
# 	Client_ID_GT1000 =        "SELECT ID, Name, BillingNumber FROM ADMIN.vClient WHERE ID>1000"
# 	ClientName_BillingName_Mismatch =        "SELECT ID, Name, BillingNumber, BillingName FROM ADMIN.vClient    WHERE ISNULL(Name, '')<> ISNULL(BillingName, '')"
# 	ClientSearchEmpty =         "SELECT * FROM ADMIN.vClient WHERE NAME = 'QA TESTER'"
# 	Client_Count_BillingNumber_NotEqualNull =             "SELECT COUNT(*) AS [COUNT]FROM ADMIN.vClient    WHERE BillingNumber IS NOT NULL"
# end

