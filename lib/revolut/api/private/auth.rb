module Revolut
  module Api
    module Private
      module Auth
      
        def signin(phone:, password:)
          data          =     {
            phone:    phone,
            password: password
          }
          
          options       =     {
            check_configuration: false,
            authenticate:        false
          }
          
          post("signin", data: data, options: options)
        end
      
        def confirm_signin(phone:, code:)
          data          =     {
            phone:    phone,
            code:     code.gsub("-", "")
          }
          
          options       =     {
            check_configuration: false,
            authenticate:        false
          }
          
          response      =   post("signin/confirm", data: data, options: options)
          
          auth_data     =   {id: response&.dig("user", "id"), access_token: response&.fetch("accessToken", nil)}
          auth_data.delete_if { |key, value| value.to_s.empty? }
          
          if !auth_data.empty?
            self.configuration.user_id        =   auth_data.fetch(:id, nil)
            self.configuration.access_token   =   auth_data.fetch(:access_token, nil)
          else
            auth_data   =   nil
          end
          
          return auth_data
        end
      
      end
    end
  end
end
