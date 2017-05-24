call bundle exec rspec spec\projectServices_Project_spec.rb --format documentation -f RspecHtmlformatter
echo "Ran Project Services RSpec test for Projects"
call bundle exec rspec spec\projectServices_Client_spec.rb --format documentation -f RspecHtmlformatter
echo "Ran Project Services RSpec test for Clients"
