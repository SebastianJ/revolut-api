module Revolut
  module Api
    class MissingConfigurationError < StandardError; end
    class AuthorizationError < StandardError; end
    
    module Errors
      MAPPING = {
        "The request should be authorized." => -> { raise ::Revolut::Api::AuthorizationError.new("Authorization failed!") },
      }
      
      def error?(response)
        if response.is_a?(Hash) && response.has_key?("message")
          message   =   response.fetch("message", nil)
          ::Revolut::Api::Errors::MAPPING.fetch(message, nil)&.call
        end
      end
    end

  end
end
