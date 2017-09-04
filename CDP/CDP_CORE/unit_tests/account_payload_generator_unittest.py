import unittest

from CDP_CORE.modules.APICalls import APICalls
from CDP_CORE.modules.AccountPayloadGenerator import AccountPayloadGenerator as payload
from CDP_CORE.modules.Payloads import Payloads


class CdpUnitTests(unittest.TestCase):
    def test_get_cdp_account_using_salesforce_id(self):
        get_account_body = payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["salesforce_id"]
        self.assertEqual(get_account_body, payload().salesforce_id)

    def test_get_account_open_caption_setting(self):
        get_open_caption = payload().get_account_open_caption_setting()
        if get_open_caption == True:
            oc_setting = True
        elif get_open_caption == False:
            oc_setting = False
        else:
            print "Did not get True or False. Check open caption value"
            raise
        self.assertEqual(oc_setting, get_open_caption)

    def test_account_payload(self):
        self.assertEqual(Payloads().payload_account["accounts"][0]["salesforce_id"], payload().salesforce_id)

    def test_payload_open_caption_off(self):
        payload_open_caption_off = Payloads().payload_open_caption_off()["accounts"][0]["open_caption"]
        self.assertEqual(payload_open_caption_off, False)

    def test_payload_open_caption_on(self):
        payload_open_caption_on = Payloads().payload_open_caption_on()["accounts"][0]["open_caption"]
        self.assertEqual(payload_open_caption_on, True)

    def test_set_account_oc_off_and_return_status_code(self):
        self.assertEqual(APICalls().set_account_oc_off_and_return_status_code(), 201)

    def test_set_account_oc_on_and_return_status_code(self):
        self.assertEqual(APICalls().set_account_oc_on_and_return_status_code(), 201)


if __name__ == '__main__':
    unittest.main()
