module Revolut
  module Api
    class Configuration
      attr_accessor :user_id, :access_token, :user_agent
      attr_accessor :device_id, :device_model
      attr_accessor :api_version, :client_version
      attr_accessor :verbose
    
      def initialize
        self.user_id          =   nil
        self.access_token     =   nil
        
        self.user_agent       =   "Revolut/com.revolut.revolut (iPhone; iOS 11.1)"
      
        self.device_id        =   SecureRandom.uuid
        self.device_model     =   "iPhone8,1"
      
        self.api_version      =   "1"
        self.client_version   =   "5.12.1"
      
        self.verbose          =   false
      end
      
    end
  end
end
