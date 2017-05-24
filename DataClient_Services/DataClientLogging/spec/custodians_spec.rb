require_relative './spec_helper'
# require_relative '../lib/Kibana'
require_relative '../lib/InputData'
require 'byebug'

describe "Adding Analytics server to a new Relativity Environment" do

	before {
		
	}
	context "When an Analytics server is added to the Relativity Environment" do
    before {
      $url = KibanaUrl.const_get($env)
      $browser.goto $url
      byebug
    }

		it "" do
			# expect()
 		end
	end

end