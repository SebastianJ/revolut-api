module Revolut
  module Api
    module Response
      class Transaction
        attr_accessor :id, :leg_id
        attr_accessor :type, :state
        attr_accessor :started_date, :updated_date, :completed_date
        attr_accessor :currency, :amount, :fee, :balance, :description, :rate
        attr_accessor :direction, :counterpart
        attr_accessor :merchant, :card
      
        def initialize(hash = {})
          self.id                       =   hash.fetch("id", nil)
          self.leg_id                   =   hash.fetch("legId", nil)
          self.type                     =   hash.fetch("type", nil)
          self.state                    =   hash.fetch("state", nil)
        
          self.started_date             =   hash.fetch("startedDate", nil)
          self.started_date             =   ::Revolut::Api::Utilities.epoch_to_utc(self.started_date) unless self.started_date.nil?
          self.updated_date             =   hash.fetch("updatedDate", nil)
          self.updated_date             =   ::Revolut::Api::Utilities.epoch_to_utc(self.updated_date) unless self.updated_date.nil?
          self.completed_date           =   hash.fetch("completedDate", nil)
          self.completed_date           =   ::Revolut::Api::Utilities.epoch_to_utc(self.completed_date) unless self.completed_date.nil?
        
          self.currency                 =   hash.fetch("currency", nil)
          self.amount                   =   hash.fetch("amount", nil)
          self.amount                   =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.amount) if !self.currency.to_s.empty? && !self.amount.nil?
        
          self.fee                      =   hash.fetch("fee", nil)
          self.fee                      =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.fee) if !self.currency.to_s.empty? && !self.fee.nil?
        
          self.balance                  =   hash.fetch("balance", nil)
          self.balance                  =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.balance) if !self.currency.to_s.empty? && !self.balance.nil?
        
          self.description              =   hash.fetch("description", nil)
        
          self.rate                     =   hash.fetch("rate", nil)
          self.direction                =   hash.fetch("direction", nil)
        
          self.counterpart              =   {}
          self.counterpart[:currency]   =   hash.fetch("counterpart", {}).fetch("currency", nil)
          self.counterpart[:amount]     =   hash.fetch("counterpart", {}).fetch("amount", nil)
          self.counterpart[:amount]     =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.counterpart[:currency], self.counterpart[:amount]) if !self.counterpart[:currency].to_s.empty? && !self.counterpart[:amount].nil?
        
          merchant_data                 =   hash.fetch("merchant", {})
          self.merchant                 =   ::Revolut::Api::Response::Merchant.new(merchant_data) if !merchant_data.empty?
        
          self.card                     =   {}
          self.card[:last_four]         =   hash.fetch("card", {}).fetch("lastFour", nil)
        end
      
        def completed?
          in_state?(:completed)
        end
      
        def pending?
          in_state?(:pending)
        end
      
        def in_state?(state)
          self.state.downcase.strip.to_sym.eql?(state)
        end
      
      end
    end
  end
end