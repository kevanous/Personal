require_relative 'includes'

shared_context "Data Client Setup" do
   let(:dataClientDetails) { dataClientDetails = {'name' => 'QA Test1234', 'segregation' => 'Shared Store', 'format' => 'User Identifier'}}
   let(:custodiansDetails) { custodians = {'firstName' => 'TestCustodian', 'middleName' => 'QA', 'lastName' => 'Automation', 'displayName' => 'TestCustodian Automation', 'identifier' => 'QATEST1'}}
   let (:repository) { repository = {'repoName' => 'ProjectDb - Nuix Current version'}}
end
