module Revolut
  module Api
    module Response
      class User
        attr_accessor :id
        attr_accessor :created_date
        attr_accessor :address
        attr_accessor :birth_date
        attr_accessor :first_name, :last_name, :phone, :email, :email_verified
        attr_accessor :state, :referral_code, :kyc, :terms_version
        attr_accessor :under_review, :risk_assessed, :locale
        attr_accessor :wallet
      
        def initialize(hash = {})
          user_data             =   hash.fetch("user", {})
          wallet_data           =   hash.fetch("wallet", {})
        
          self.id               =   user_data.fetch("id", nil)
          self.created_date     =   user_data.fetch("createdDate", nil)
          self.created_date     =   ::Revolut::Api::Utilities.epoch_to_utc(self.created_date) unless self.created_date.nil?
          self.address          =   ::Revolut::Api::Response::Address.new(user_data.fetch("address", {}))
          self.birth_date       =   user_data.fetch("birthDate", nil)
          self.first_name       =   user_data.fetch("firstName", nil)
          self.last_name        =   user_data.fetch("lastName", nil)
          self.phone            =   user_data.fetch("phone", nil)
          self.email            =   user_data.fetch("email", nil)
          self.email_verified   =   user_data.fetch("emailVerified", false)
          self.state            =   user_data.fetch("state", nil)
          self.referral_code    =   user_data.fetch("referralCode", nil)
          self.kyc              =   user_data.fetch("kyc", nil)
          self.terms_version    =   user_data.fetch("termsVersion", nil)
          self.under_review     =   user_data.fetch("underReview", false)
          self.risk_assessed    =   user_data.fetch("riskAssessed", false)
          self.locale           =   user_data.fetch("locale", nil)
        
          self.wallet           =   ::Revolut::Api::Response::Wallet.new(wallet_data)
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
