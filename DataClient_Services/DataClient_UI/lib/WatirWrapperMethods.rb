require_relative 'includes'

class WatirWrapperMethods
    def element_by_css(selector, timeout = 30)
        elements = self.elements_by_css(selector, timeout)
        return elements.length > 0 ? elements[0] : $browser.element(:css => selector)
    end

    def elements_by_css(selector, timeout = 30)
        message = "waiting for #{selector} to become present"
        Watir::Wait.until(timeout, message) { $browser.execute_script("return $('%s').length" % selector) > 0 }
        return $browser.execute_script("return $('%s')" % selector)
    end

    def css_by_text(css, text)                
        text_element = $browser.elements(:css => css ).find{ |element| element.text == text }.wait_until_present
        if text_element.visible? == true
            text_element.click
        else
            puts "no element visible to click"
        end            
    end

    def wait_while_spinning
        $browser.element(:css=>'dataclient-detail request-queue-status md-progress-circular').wait_while_present
        $browser.element(:css=>'dataclient-selecter request-queue-status md-progress-circular').wait_while_present
        $browser.element(:css=>'project-selecter request-queue-status md-progress-circular').wait_while_present
        $browser.element(:css=>'customAttributesDialog request-queue-status md-progress-circular').wait_while_present
    end

end