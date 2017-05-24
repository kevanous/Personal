require 'tiny_tds'
require_relative 'Intake_Information'
require_relative 'Apc'
require 'byebug'

class SqlUpdate
	include TestFramework
	include Consilio

	@apc = Apc.new
	@intakeinformation = IntakeInformation.new
	
	def sqlUpdateAPC
		client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'H12568_EDD', username: 'username', password: 'Password',timeout: 1000
		groupIdentifier = @apc.GetGroupIdentifier
		update = "UPDATE EXT.allCustodianTopLevel  
		  					SET fkCustID = fkCustID + 1
		 					 	WHERE topLevelGuid like '%#{groupIdentifier}%'"
		  
		update_result = client.execute(update)
		 
		select = "SELECT fkCustID 
								FROM EXT.allCustodianTopLevel
		            WHERE topLevelGuid like '%#{groupIdentifier}%'"
		            

		select_result = client.execute(select)
		
	  select_result.each do |row|
	  	@sql_CustId = row["fkCustID"]
  	end  	
  	return @sql_CustId
  end

  def sqlUpdateRDO()
  	client = TinyTds::Client.new dataserver:'MLVUDPRJ01', database:'H12568_EDD', timeout: 1000
  	select = "SELECT displayName FROM Source.Custodian WHERE custID = '#{custID}';"
		select_result_custodianName = client.execute(select)
		rdo_update = "UPDATE Source.custodian
		SET displayName = displayName + '_NEW_TEST_KUMAR'
		WHERE custId IN ('114);"
  	update_result_rdo = client.execute(rdo_update)
  end

end
