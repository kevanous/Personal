=begin

# require 'chef'
# require 'openssl'
require 'nokogiri'
require 'ridley'

class XMLParser
	def initialize(filepath)
		File.open(filepath) do |f|
			@root = Nokogiri::XML(f).root
		end
	end

	def getValue(nodeName)
		return @root.at_xpath(nodeName).text
	end
end

$globalUrls = XMLParser.new('config.xml')

# AQUIRE CLUSTER NAME FROM THE CONFIG.XML FILE
clustername = $globalUrls.getValue("Cluster_name")

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

chef_server = Ridley.new(
  server_url: "https://chef.consilio.com/organizations/consilio-dev",
  client_name: 'kshrestha',
  client_key: "C:/Chef/kshrestha.pem",
  ssl: {verify: false}
)

# # Chef::Config.from_file("#{ENV['HOME']}/.chef/knife.rb")
# Chef::Config.from_file("C:/.chef/knife.rb")

# # VERIFY CONNECTION TO THE CHEF SERVER IS OPEN ##
# puts "=== Connected to [#{Chef::Config[:chef_server_url]}] ==="
# puts "cluster name is: #{clustername}"

# #GET THE WEB URL THAT REQUIRES USERNAME AND PASSWORD:
fqdn_rdc = chef_server.node.find("#{clustername}-rdc0").automatic.fqdn
puts("Cluster Name  : #{clustername}\nFQDN_rdc      : #{fqdn_rdc}")
$rdc_url = "https://#{fqdn_rdc}/Relativity"
# fqdn_rdc =  Chef::Node.load("#{clustername}-rdc0").automatic.fqdn
# $rdc_url = "https://#{fqdn_rdc}/Relativity"

# #GET THE WEB URL THAT USES WINDOWS AUTHENTICATION:
fqdn_sso = chef_server.node.find("#{clustername}-web0").automatic.fqdn
puts("FQDN_sso      : #{fqdn_sso}")
$sso_url = "https://#{fqdn_sso}/Relativity"
# fqdn_sso = Chef::Node.load("#{clustername}-web0").automatic.fqdn
# $sso_url = "https://#{fqdn_sso}/Relativity"

# # GET THE WORKER SERVER NAME:
hostname_worker = chef_server.node.find("#{clustername}-wrk0").automatic.hostname
puts("FQDN_worker   : #{hostname_worker}")
# hostname_worker =  Chef::Node.load("#{clustername}-wrk0").automatic.hostname
$wrk_name = hostname_worker

# # GET THE AGENT SERVER NAME:
hostname_agent = chef_server.node.find("#{clustername}-agt0").automatic.hostname
puts("FQDN_agent    : #{hostname_agent}")
$agt_name = hostname_agent
# hostname_agent =  Chef::Node.load("#{clustername}-agt0").automatic.hostname
# $agt_name = hostname_agent

# # GET THE ANALYTICS SERVER'S SERVICE NAME:
fqdn_analytics = chef_server.node.find("#{clustername}-anx0").automatic.hostname
$anx_service = "https://#{fqdn_analytics}:8080/nexus/services/"
# fqdn_analytics =  Chef::Node.load("#{clustername}-anx0").automatic.fqdn
# $anx_service = "https://#{fqdn_analytics}:8080/nexus/services/"

# # GET THE WORKER MANAGER SERVER'S SERVICE NAME:
fqdn_wms = chef_server.node.find("#{clustername}-wms").automatic.hostname
$wms_service = "https://#{fqdn_wms}::6859/InvariantAPI/"
# fqdn_wms =  Chef::Node.load("#{clustername}-wms").automatic.fqdn
# $wms_service = "https://#{fqdn_wms}:6859/InvariantAPI/"

=end

module RelativityUrl
	Local = "https://relativity92test.huronconsultinggroup.com/Relativity"
	Test = "https://mlvtwrew31.huronconsultinggroup.com/Relativity"
	Prod = "https://relativity.huronconsultinggroup.com/Relativity"
	# Automation = "https://relativity92test.huronconsultinggroup.com/Relativity"
	# Automation = "https://mtpctscid023.consilio.com/Relativity"
	Automation = "https://mtpctscid021.consilio.com/Relativity"
	# Automation = $sso_url
	Automation_forms = "https://mtpctscid021.consilio.com/Relativity"
	# Automation_forms = $rdc_url
	puts "SSO URL is    : #{Automation}"
	puts "forms URL is  : #{Automation_forms}"
end

module ServerTypes
	Analytics = "Analytics Servers"
	WMS = "Worker Manager Server"
	Agent_Worker = "Agent and Worker Servers"
	# Agent_Name = $agt_name
	# Worker_Name= $wrk_name
	Agent_Name = "MTPCTSCID022"
	Worker_Name= "MTPCTSCID025"
end

module RelativityWorkspaceItems
	WorkspaceName = "H12568 - HCG - Enron - Nuix 6.2"
	AgentName = "Custodian Update Agent (1)"
	WorkspaceNameSmoke = "Smoke Workspace"
	WorkspaceAdmin = 'Workspace Admin'
end

module DedupeHistoryRunsColumns
	Status = 3
	SavedSearchUsed = 5
	FieldUpdated = 6
	DeduplicationType =  7
	TotalDocuments = 8
	UniqueDocuments = 9
	NonUniqueDocuments = 10
end

module DedupeInputs
	SuccessfulRun = "Success"
	SavedSearchName = 'H12568 - HCG - Enron - Nuix 6.2 \ Dedupe_Test1'
	FieldName = 'BD EMT IsMessage'
	DeDuplicationTypeName = 'Document'
end

module ApplicationNames
	ApcUpdate = 'All Processed Custodian Update'
	Dedupe = 'Dedupe Saved Search'
	Documents ='Documents'
	IntakeInformation = 'Intake Information'
	Reporting = 'Reporting'
	WorkspaceAdmin = 'Workspace Admin'
end

module AnalyticsIndexField
	Name = 'Smoke Analytics'
	Status ='Yes'
end

module STR
	Name ='Smoke STR'
	Status ='Completed'
end

# module AddAnalyticsServer
# 	Name ='Smoke Analytics Server'
# 	URL = $anx_service
# 	RestAPIPort ='8443'
# 	RestUsername ='SLT_REL2'
# 	RestPass ='P@ssword01'
# 	Status ='Active'
# 	puts "Analytics URL : #{URL}"
# end

module AddWMS
	Name ='Smoke WMS'
	# URL = $wms_service
	URL = "MTPCTSCID027"
  Status ='Active'
  puts "WMS URL       : #{URL}"
end

module GroupAccessNames
	Agents = "Server & Agent Management"
	Workspaces = "Workspaces"
	User_GroupMgmt = "User and Group Management"
end

module CreateSmokeItems
	Client = "Smoke Client"
	Matter = "Smoke Matter"
	UserFirstName = "Smoke"
	UserLastName =	"User"
	FullName = UserLastName+", "+UserFirstName
	# Email = "Smokeuser@kcura.com"
	Email = "relativity.admin@kcura.com"
	# Password = "Password2!"
	Password = "Test1234!"
	GroupName = "Smoke Group"
end
	
module CreateInternalUsers
	Client_Int	=  "Relativity"
	UserFirstName = "Harsh"
	UserLastName =	"Parikh"
	FullName = UserLastName+", "+UserFirstName
	FirstInitialLastName = (UserFirstName[0]+UserLastName).downcase
	Email = FirstInitialLastName+"@consilio.com"
	Password = "Password1!"
	AuthData = "consilio\\"+FirstInitialLastName
end

module WorkspaceElements
	FieldName = "Smoke Designation"
	FieldType = "Single Choice"
	ChoiceName1 = "Smoke Responsive"
	ChoiceName2 = "Smoke Non-Responsive"
	LayoutName = "Smoke Layout"
	ViewName = "Smoke Responsive Documents"
	Operator = "any of these"
	SavedSearchName = "Smoke Search 1"
	FolderName = "JHERNANDE_0000565"
	DtSearchName = "Smoke dtSearch"
end

module CodingResponsive
	DocumentControlNumber = "JHERNANDE_0000568"
	ReportName = "Smoke Summary Report"
end

module ParentDocIDField
	ParentIDName = "Parent Document ID"
	ParentFieldType = "Fixed-Length Text"
end

module WorkspaceAdminTabs
	WorkspaceDetails = "Workspace Details"
	SearchIndexes = "Search Indexes"
	ObjectType = "Object Type"
	Fields = "Fields"
	Choices = "Choices"
	Layouts = "Layouts"
	Views = "Views"
	Tabs = "Tabs"
	RelativityApps = "Relativity Applications"
	CustomPages = "Custom Pages"
	History = "History"
	UserStatus = "User Status"
end

module SearchField
	ControlNumber = "ControlNumber"
	Name = "DisplayName"
	DocumentNumber = "TRANS_00001"
end

module TranscriptAddHeaderFooter
	HeaderText = "Document Header"
  FooterText = "Documant Footer"
end

module WordIndex
	Search_Word1 = "PETER"
	Search_Word2 = "Declaration"
end

module AdminLogin
	RelAdminUser = "relativity.admin@kcura.com"
	Password = "Test1234!"
end
