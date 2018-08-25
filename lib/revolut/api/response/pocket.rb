module Revolut
  module Api
    module Response
      class Pocket
        attr_accessor :id, :state
        attr_accessor :currency
        attr_accessor :balance, :blocked_amount
      
        def initialize(hash = {})
          self.id               =   hash.fetch("id", nil)
          self.state            =   hash.fetch("state", nil)
        
          self.currency         =   hash.fetch("currency", nil)
        
          self.balance          =   hash.fetch("balance", nil)
          self.balance          =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.balance) if !self.currency.to_s.empty? && !self.balance.nil?
        
          self.blocked_amount   =   hash.fetch("blockedAmount", nil)
          self.blocked_amount   =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.blocked_amount) if !self.currency.to_s.empty? && !self.blocked_amount.nil?
        end
      
        def active?
          in_state?(:active)
        end
      
        def in_state?(state)
          self.state.downcase.strip.to_sym.eql?(state)
        end
      
      end
    end
  end
end