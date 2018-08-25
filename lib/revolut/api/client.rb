module Revolut
  module Api
    class Client < ::Revolut::Api::Base
    
      def initialize(host: "api.revolut.com", configuration: ::Revolut::Api.configuration)
        super(host: host, configuration: configuration)
      
        set_headers
      end
    
      def set_headers
        self.headers.merge!({
          'X-Client-Version'  =>  self.configuration.client_version,
          'X-Api-Version'     =>  self.configuration.api_version,
          'X-Device-Id'       =>  self.configuration.device_id,
          'X-Device-Model'    =>  self.configuration.device_model
        })
        
        self.headers.delete_if { |key, value| value.to_s.empty? }
      end
      
      include ::Revolut::Api::Private::Auth
      include ::Revolut::Api::Private::User
      include ::Revolut::Api::Private::Exchange
      include ::Revolut::Api::Private::Transactions
    
    end
  end
end
