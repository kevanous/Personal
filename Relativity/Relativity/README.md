# Relativity
Relativity Automation Testing in RSpec


To run end-to-end testing on an existing Relativity 9.3 environment:

- Clone this repo to your local or test machine.
  - The tests require access to `\\HLNAS00\tech\Packages\SmokeTestDataImport`
- Run `bundle install` to get/update the Ruby gems needed.
- Update `config.xml` with the appropriate Relativity server URLs:
  - *HINT:* run `knife search node "tags:*Relativity*"` to get the server info from the Chef Server
- In the local clone, navigate to the `Relativity` folder and run `rspec_exec.bat` to execute the tests.
