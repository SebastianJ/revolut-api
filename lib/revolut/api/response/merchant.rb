module Revolut
  module Api
    module Response
      class Merchant
        attr_accessor :mapping
        attr_accessor :id, :scheme, :name, :mcc, :country, :state, :city, :postcode, :address, :category
      
        MAPPING                 =   {
          "id"            =>  :id,
          "scheme"        =>  :scheme,
          "name"          =>  :name,
          "mcc"           =>  :mcc,
          "country"       =>  :country,
          "state"         =>  :state,
          "city"          =>  :city,
          "postcode"      =>  :postcode,
          "address"       =>  :address,
          "category"      =>  :category,
        }
      
        def initialize(hash = {})
          ::Revolut::Api::Response::Merchant::MAPPING.each do |revolut_key, accessor|
            self.send("#{accessor}=", hash.fetch(revolut_key, nil))
          end
        end
      
      end
    end
  end
end
