from Payloads import Payloads
from modules.api_base import ApiBase
from resources.private.config import CDP_STAGING_API_KEY, CDP_STAGING_API_HOST


class APICalls(object):
    def __init__(self):
        self.api = ApiBase()
        self.api.add_to_header("Authorization", CDP_STAGING_API_KEY)

    def set_account_oc_off_and_return_status_code(self):
        self.api.set_url(CDP_STAGING_API_HOST + 'api/v1/accounts')
        self.api.put(Payloads().payload_open_caption_off())
        return self.api.get_status_code()

    def set_account_oc_on_and_return_status_code(self):
        self.api.set_url(CDP_STAGING_API_HOST + 'api/v1/accounts')
        self.api.put(Payloads().payload_open_caption_on())
        return self.api.get_status_code()
