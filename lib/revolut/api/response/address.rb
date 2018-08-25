module Revolut
  module Api
    module Response
      class Address
        attr_accessor :mapping
        attr_accessor :country, :city, :postcode, :region, :street_line_one, :street_line_two
      
        MAPPING                 =   {
          "country"       =>  :country,
          "city"          =>  :city,
          "postcode"      =>  :postcode,
          "region"        =>  :region,
          "streetLine1"   =>  :street_line_one,
          "streetLine2"   =>  :street_line_two
        }
      
        def initialize(hash = {})
          ::Revolut::Api::Response::Address::MAPPING.each do |revolut_key, accessor|
            self.send("#{accessor}=", hash.fetch(revolut_key, nil))
          end
        end
      
        def to_api_hash
          hash                  =   {}
        
          ::Revolut::Api::Response::Address::MAPPING.each do |revolut_key, accessor|
            hash[revolut_key]   =   self.send(accessor)
          end
        
          return hash
        end
      
      end
    end
  end
end