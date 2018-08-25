module Revolut
  module Api
    module Response
      class CardIssuer
        attr_accessor :mapping
        attr_accessor :bin, :name, :logo_url
        attr_accessor :card_type, :card_brand
        attr_accessor :currency, :supported
      
        MAPPING   =   {
          "bin"         =>  :bin,
          "name"        =>  :name,
          "logoUrl"     =>  :logo_url,
          "cardType"    =>  :card_type,
          "cardBrand"   =>  :card_brand,
          "currency"    =>  :currency,
          "supported"   =>  :supported
        }
      
        def initialize(hash = {})
          ::Revolut::Api::Response::CardIssuer::MAPPING.each do |revolut_key, accessor|
            self.send("#{accessor}=", hash.fetch(revolut_key, nil))
          end
        end
      
      end
    end
  end
end
