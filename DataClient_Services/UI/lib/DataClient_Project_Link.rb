require_relative 'includes'

class DataClient_Project_Link

	def dataClientTitle
		# $browser.title
		$browser.elements(:css=>'#tab-content-0 > div > md-card-content > dataclient-selecter > md-card > div.card-table > table > tbody').size
	sleep 5
	end
end