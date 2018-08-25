require "yaml"

def setup_configuration
  cfg_path                    =   File.join(File.dirname(__FILE__), "../../credentials.yml")
  
  if ::File.exists?(cfg_path)
    cfg                       =   YAML.load_file(cfg_path)

    Revolut::Api.configure do |config|
      config.user_id          =   cfg["user_id"]
      config.access_token     =   cfg["access_token"]
    
      config.user_agent       =   cfg["user_agent"]
    
      config.device_id        =   cfg["device_id"]
      config.device_model     =   cfg["device_model"]
    
      config.api_version      =   cfg["api_version"]
      config.client_version   =   cfg["client_version"]
    
      config.verbose          =   false
    end
  else
    raise "Missing credentials.yml file - you need to create one and include user id and access token in order to run specs for private API endpoints."
  end
end
