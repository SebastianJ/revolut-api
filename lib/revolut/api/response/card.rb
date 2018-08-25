module Revolut
  module Api
    module Response
      class Card
        attr_accessor :id, :owner_id
        attr_accessor :last_four, :brand
        attr_accessor :expiry_date, :expired
        attr_accessor :three_d_verified, :address, :issuer
        attr_accessor :currency, :confirmed, :confirmation_attempts, :auto_topup
        attr_accessor :created_date, :updated_date, :last_used_date
        attr_accessor :topup_limit, :current_topup
      
        def initialize(hash = {})
          self.id                       =   hash.fetch("id", nil)
          self.owner_id                 =   hash.fetch("ownerId", nil)
          self.last_four                =   hash.fetch("lastFour", nil)&.to_i
          self.brand                    =   hash.fetch("brand", nil)
        
          self.expiry_date              =   {
            month: hash.fetch("expiryDate", {}).fetch("month", nil),
            year:  hash.fetch("expiryDate", {}).fetch("year", nil),
          }
        
          self.three_d_verified         =   hash.fetch("threeDVerified", false)
        
          address_data                  =   hash.fetch("address", {})
          self.address                  =   ::Revolut::Api::Response::Address.new(address_data)
        
          issuer_data                   =   hash.fetch("issuer", {})
          self.issuer                   =   ::Revolut::Api::Response::CardIssuer.new(issuer_data)
        
          self.currency                 =   hash.fetch("currency", nil)
          self.confirmed                =   hash.fetch("confirmed", false)
          self.confirmation_attempts    =   hash.fetch("confirmationAttempts", 0)
          self.auto_topup               =   hash.fetch("autoTopup", nil)
        
          self.created_date             =   hash.fetch("createdDate", nil)
          self.created_date             =   ::Revolut::Api::Utilities.epoch_to_utc(self.created_date) unless self.created_date.nil?
          self.updated_date             =   hash.fetch("updatedDate", nil)
          self.updated_date             =   ::Revolut::Api::Utilities.epoch_to_utc(self.updated_date) unless self.updated_date.nil?
          self.last_used_date           =   hash.fetch("lastUsedDate", nil)
          self.last_used_date           =   ::Revolut::Api::Utilities.epoch_to_utc(self.last_used_date) unless self.last_used_date.nil?
        
          self.topup_limit              =   hash.fetch("topupLimit", nil)
          self.topup_limit              =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.topup_limit) if !self.currency.to_s.empty? && !self.topup_limit.nil?
        
          self.current_topup            =   hash.fetch("currentTopup", nil)
          self.current_topup            =   ::Revolut::Api::Utilities.convert_from_integer_amount(self.currency, self.current_topup) if !self.currency.to_s.empty? && !self.current_topup.nil?
        end
      
      end
    end
  end
end