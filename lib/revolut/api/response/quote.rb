module Revolut
  module Api
    module Response
      class Quote
        attr_accessor :from, :to
        attr_accessor :fee, :rate, :markup
        attr_accessor :epoch, :timestamp
        attr_accessor :success, :message
      
        def initialize(hash = {})
          if hash.has_key?("message")
            self.message                  =   hash.fetch("message")
            self.success                  =   false
        
          else
            self.from                     =   {}
            self.to                       =   {}
            self.fee                      =   {}
        
            set_amount_hash("from", hash)
            set_amount_hash("to", hash)
            set_amount_hash("fee", hash)
        
            self.rate                     =   hash.fetch("rate", nil)
            self.markup                   =   hash.fetch("markup", nil)
        
            self.epoch                    =   hash.fetch("timestamp", nil)
            self.timestamp                =   ::Revolut::Api::Utilities.epoch_to_utc(self.epoch)
          
            self.success                  =   true
          end
        end
      
        def set_amount_hash(key, hash)
          if hash.has_key?(key)
            sub_item                      =   hash.fetch(key, {})
          
            if sub_item.is_a?(Hash)
              self.send(key)[:currency]     =   sub_item.fetch("currency", nil)
              self.send(key)[:base_amount]  =   sub_item.fetch("amount", nil)
              self.send(key)[:amount]       =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.send(key)[:currency], self.send(key)[:base_amount]) if !self.send(key)[:currency].to_s.empty? && !self.send(key)[:base_amount].nil?
          
            elsif sub_item.is_a?(String)
              self.send("#{key}=", sub_item)
            end
          end
        end
      
      end
    end
  end
end
