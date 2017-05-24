require 'watir'
require 'byebug'

    # Watir.relaxed_locate = false
    $browser = Watir::Browser.new :chrome
    
    # $browser=Watir::Browser.new( :chrome, :switches => %w[ --disable-extensions ] )
    # $browser.driver.manage.window.maximize

    $browser.goto"http://mtpctscid303.consilio.com/"
    # Watir.relaxed_locate = false
    # $browser.elements(:css => 'md-tab-item').find{ |element| element.text == "PROJECTS" }.wait_until(&:present?).click
    # $browser.element(:css=>'md-tab-item').wait_until(&:present?).click
    byebug
    $browser.element(:css=>'md-tab-item').wait_until(&:present?).click
    byebug


    # sleep 5
