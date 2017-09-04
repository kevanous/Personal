import copy

from CDP_CORE.modules.AccountPayloadGenerator import AccountPayloadGenerator as payload


class Payloads(object):
    payload_account = {
        "accounts": [
            {
                "cmh_id": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["cmh_id"],
                "name": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["name"],
                "open_caption": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["summary"]["open_caption"],
                "exclude_ticker": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["summary"]["exclude_ticker"],
                "parent_salesforce_id": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["parent_salesforce_id"],
                "salesforce_id": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["salesforce_id"],
                "status": "active",
                "specialities": payload().get_cdp_account_using_salesforce_id()["data"][0]["attributes"]["summary"]["account_specialities"]
            }
        ]
    }

    def payload_open_caption_off(self):
        payload_account_copy = copy.deepcopy(Payloads().payload_account)
        payload_account_copy["accounts"][0]["open_caption"] = False
        return payload_account_copy

    def payload_open_caption_on(self):
        payload_account_copy = copy.deepcopy(Payloads().payload_account)
        payload_account_copy["accounts"][0]["open_caption"] = True
        return payload_account_copy
