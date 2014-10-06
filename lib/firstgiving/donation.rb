require 'crack'

module FirstGiving
  class Donation
    include Base

    module Actions
      CREDITCARD = '/donation/creditcard'
      CARD_ON_FILE = '/cardonfile'
      RECURRING_CREDITCARD_PROFILE = '/donation/recurringcreditcardprofile'
      VERIFY = '/verify'
    end

    def initialize
      @api_endpoint = DONATION_PRODUCTION_ENDPOINT
      @api_endpoint = DONATION_SANDBOX_ENDPOINT if FirstGiving.configuration.options[:use_staging]
    end

    def headers
      headers_json.merge!(headers_security)
    end

    def creditcard(params)
      response = post_call(@api_endpoint, Actions::CREDITCARD, params, headers)
      parse(response.body)
    end
    
    def cardonfile(params)
      response = post_call(@api_endpoint, Actions::CARD_ON_FILE, params, headers)
      parse(response.body)
    end

    def verify(params)
      response = get_call(@api_endpoint, Actions::VERIFY, params, headers)
      parse(response.body)
    end

    def recurring_creditcard_profile(params)
      call(Actions::RECURRING_CREDITCARD_PROFILE, params, headers)
    end

    def parse(body)
      Crack::XML.parse(body)
    end
  end
end
