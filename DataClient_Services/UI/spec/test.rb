require 'watir'
require 'watir-webdriver'
require 'byebug'

$browser = Watir::Browser.new :chrome

$browser.driver.manage.window.maximize

$browser.goto('http://mtpctscid968.consilio.com/')

sleep 2
# body > md-content > md-content > div.flex-40 > md-card > md-tabs > md-tabs-wrapper > md-next-button > md-icon

byebug
$browser.element(:css => 'body > md-content > md-content > div.flex-40 > md-card > md-tabs > md-tabs-wrapper > md-next-button > md-icon').click
byebug
