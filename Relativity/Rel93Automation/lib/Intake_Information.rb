require 'rubygems'
require 'bundler/setup'
require 'TestFramework'
require_relative 'RelativityWorkspace'
require 'byebug'

class IntakeInformation < RelativityWorkspace
	include Consilio
	include TestFramework

	def custodianID
		self.column_resize_wait
		return self.iframe_main.tr(:id => 'ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0').tds[3].text
	end

	def custodianName
		return self.iframe_main.tr(:id => 'ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0').tds[4].text
	end

end