from modules.api_base import ApiBase
from resources.private.config import CDP_STAGING_API_KEY, CDP_STAGING_API_HOST


class AccountPayloadGenerator(object):
    salesforce_id = "001Q0000017thwlIAA"  # hardcoded until we have a REST API call to get a random account
    account_search_endpoint = "api/v1/search/accounts?salesforce_id={}"

    def __init__(self):
        self.api = ApiBase()
        self.api.add_to_header("Authorization", CDP_STAGING_API_KEY)

    def get_cdp_account_using_salesforce_id(self):
        self.api.set_url(CDP_STAGING_API_HOST + self.account_search_endpoint.format(self.salesforce_id))
        return self.api.get()

    def get_account_open_caption_setting(self):
        get_body = self.get_cdp_account_using_salesforce_id()
        return get_body["data"][0]["attributes"]["summary"]["open_caption"]
