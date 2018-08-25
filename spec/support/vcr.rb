require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
  
  %w(user_id access_token device_id).each do |config_key|
    c.filter_sensitive_data(config_key.upcase) do |interaction|
      Revolut::Api.configuration.send(config_key)
    end
  end
  
  c.filter_sensitive_data("BASIC_AUTH") do |interaction|
    "Basic #{Base64.strict_encode64("#{Revolut::Api.configuration.user_id}:#{Revolut::Api.configuration.access_token}").strip}"
  end
  
end
