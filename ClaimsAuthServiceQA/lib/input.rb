module ClaimsAuthUrls
  SERVICES_URL = 'http://MLVDWSRV02:8081/odata/'.freeze
  # SERVICES_URL = 'http://kumarMLVDWSRV02:8081/odata/'.freeze # non existing url
end

module ConfigFile
  ConfigFile_JSON = 'config.json'
end

module UserInfo
  DomainAdmin = 'ST_InfoSec_User'
  AdminPassword = 'p9&61)4297=M'
  DomainUser = ENV['Test_UserName']
  UserPassword = ENV['Test_Password']
end

