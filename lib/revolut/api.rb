require "base64"
require "json"
require "securerandom"

require "faraday"
require "faraday_middleware"

require "revolut/api/version"

require "revolut/api/constants"
require "revolut/api/errors"
require "revolut/api/utilities"
require "revolut/api/configuration"

require "revolut/api/response/user"
require "revolut/api/response/address"
require "revolut/api/response/wallet"
require "revolut/api/response/pocket"
require "revolut/api/response/card_issuer"
require "revolut/api/response/card"
require "revolut/api/response/transaction"
require "revolut/api/response/merchant"
require "revolut/api/response/quote"

require "revolut/api/base"

require "revolut/api/private/auth"
require "revolut/api/private/user"
require "revolut/api/private/exchange"
require "revolut/api/private/transactions"

require "revolut/api/client"
require "revolut/api/public/client"

require 'revolut/api/railtie' if defined?(Rails)

module Revolut
  module Api
    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration  ||=   ::Revolut::Api::Configuration.new
    end

    def self.reset
      @configuration    =   ::Revolut::Api::Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
