require_relative '../lib/includes'

describe "a" do
	before :all do
		@dataClient = DataClient_Project_Link.new
		 $url = DataClient_URL.const_get($env)
      $browser.goto $url
		# puts "code here"
	end

	# include_context ""
=begin

Context: Data Client to Projects
	
	1st test: Select All for Filter, get a count of all data clients in the UI, compare that with the count from API call
	Validation: It is the same

	2nd test: click on add Data Client, follow all the steps for adding a new data client
	Validation: Search for the newly added Data Client in the search box, and it should be available under the Data Client list shown

	3rd test: Test the Data Client Filter(Not implemented yet, reqs incomplete, so ignore for now)
	Validation: Only the Data Client that are under the filtered type should be available

	4th test: Search for a particular Data Client, then select All for Projects and select one project, then save
	Validation: Search for that particular Data Client, then select that Data Client in Filter under Projects, and here only the previously selected project should be available
	
	5th test: Select a Data Client, then select All for Projects and select multiple projects, then save
	Validation: Search for that particular Data Client, the select that particular Data Client in Filter under Projects, and here only the previously selected projects should be available
	
	6th test: Click on add Data Client, follow all the steps for adding a new data client
	Validation: Search for the newly added Data Client in the search


	Context: Projects to Data Clients
		1st test: Test the Projects Filter, for all types (Not implemented yet, reqs complete)
		Validation: Only the projects that have an association with a the chosen filter should be available in the result list

		2nd test: Select All for filter, search for a particular Project in the search field, click on that project, click on a particular data client name check box and save
		Validation: The selected data client should now be associated with the project

		3rd test: 

=end

	context "b" do
		it "c" do
			expect($browser.title).to eq "Data Client Manager"
		end

		it "d" do
			# expect(@dataClient.dataClientList_Count).to eq (@sql.DataClientCount)
	end

end

