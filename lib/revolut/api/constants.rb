module Revolut
  module Api
    class Constants
    
      CRYPTOS       =   [
        'BTC',
        'LTC',
        'ETH',
        'XRP'
      ]
    
      BASE_UNITS    =   {
        fiat:       100.0,
        crypto:     100_000_000.0
      }
    
      TIME          =   {
        epoch_base: 1_000,
        one_month:  2629746
      }
    
      PUBLIC_USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"
        
    end
  end
end
