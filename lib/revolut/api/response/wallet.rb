module Revolut
  module Api
    module Response
      class Wallet
        attr_accessor :id, :ref, :state
        attr_accessor :base_currency
        attr_accessor :total_topup
        attr_accessor :pockets
      
        def initialize(hash = {})
          self.id             =   hash.fetch("id", nil)
          self.ref            =   hash.fetch("ref", nil)
          self.state          =   hash.fetch("state", nil)
        
          self.base_currency  =   hash.fetch("baseCurrency", nil)
        
          self.total_topup    =   hash.fetch("totalTopup", nil)
          self.total_topup    =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.base_currency, self.total_topup) if !self.base_currency.to_s.empty? && !self.total_topup.nil?
      
          self.pockets        =   {}
          hash.fetch("pockets", []).each do |pocket_data|
            pocket                          =   ::Revolut::Api::Response::Pocket.new(pocket_data)
            self.pockets[pocket.currency]   =   pocket 
          end
        end
      
        def active?
          in_state?(:active)
        end
      
        def in_state?(state)
          self.state.downcase.strip.to_sym.eql?(state)
        end
      
        def pocket(currency)
          self.pockets.fetch(currency, nil)
        end
      
      end
    end
  end
end
