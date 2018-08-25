module Revolut
  module Api
    module Private
      module User
      
        def user
          ::Revolut::Api::Response::User.new(get("user/current"))
        end
      
        def wallet
          ::Revolut::Api::Response::Wallet.new(get("user/current/wallet"))
        end
    
        def cards
          get("user/current/cards")&.collect { |response| ::Revolut::Api::Response::Card.new(response) }
        end
      
        def update_address(city: nil, country: nil, postcode: nil, region: nil, street_line_one: nil, street_line_two: nil)
          response                    =   nil
          address                     =   user.address
      
          if address
            address.city              =   city            unless city.nil?
            address.country           =   country         unless country.nil?
            address.postcode          =   postcode        unless postcode.nil?
            address.region            =   region          unless region.nil?
            address.street_line_one   =   street_line_one unless street_line_one.nil?
            address.street_line_two   =   street_line_two unless street_line_two.nil?
      
            payload                   =   {"address" => address.to_api_hash}      
            response                  =   patch("user/current", data: payload)
          end
          
          return response
        end
      
      end
    end
  end
end
