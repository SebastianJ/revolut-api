module Revolut
  module Api
    class Utilities
      
      class << self
        def epoch_to_utc(time)
          Time.at(time/::Revolut::Api::Constants::TIME[:epoch_base]).utc
        end
    
        def utc_to_epoch(time)
          time.to_i * ::Revolut::Api::Constants::TIME[:epoch_base]
        end
    
        # Revolut uses cents, so if you send in $10, multiply by 100 to get Revolut's internal prices
        def convert_to_integer_amount(currency, amount)
          sub_unit    =   ::Revolut::Api::Constants::CRYPTOS.include?(currency) ? ::Revolut::Api::Constants::BASE_UNITS[:crypto] : ::Revolut::Api::Constants::BASE_UNITS[:fiat]
          (amount.to_f * sub_unit).round(0).to_i
        end
    
        def convert_from_integer_amount(currency, amount)
          sub_unit    =   ::Revolut::Api::Constants::CRYPTOS.include?(currency) ? ::Revolut::Api::Constants::BASE_UNITS[:crypto] : ::Revolut::Api::Constants::BASE_UNITS[:fiat]
          (amount.to_f / sub_unit)
        end
      end
    
    end
  end
end
