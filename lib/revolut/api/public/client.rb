module Revolut
  module Api
    module Public
    
      class Client < ::Revolut::Api::Base
        def initialize(host: "www.revolut.com")
          super(host: host)
        end
    
        def quotes(from: [], to: [], endpoint: "api/quote/internal")
          options     =   {
            user_agent:           ::Revolut::Api::Constants::PUBLIC_USER_AGENT,
            authenticate:         false,
            check_configuration:  false
          }
          
          super(from: from, to: to, endpoint: endpoint, options: options)
        end
    
      end
    
    end
  end
end
