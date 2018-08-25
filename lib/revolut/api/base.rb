module Revolut
  module Api
    class Base
      attr_accessor :host, :configuration, :headers, :memoized
    
      def initialize(host: "api.revolut.com", configuration: ::Revolut::Api.configuration)
        self.host             =   host
        
        self.configuration    =   configuration
        
        self.headers          =   {
          'Host'  =>  self.host
        }
        
        self.memoized         =   {}
      end
      
      include ::Revolut::Api::Errors
    
      def to_uri(path)
        "https://#{self.host}/#{path}"
      end
      
      def check_configuration!
        %w(user_id access_token user_agent device_id device_model).each do |config_key|
          raise ::Revolut::Api::MissingConfigurationError, "You need to specify the #{config_key.gsub("_", " ")}!" if ::Revolut::Api.configuration.send(config_key).to_s.empty?
        end
      end
    
      def quotes(from: [], to: [], endpoint: "quote", options: {})
        from        =   (from.is_a?(Array) ? from : split_to_array(from)).collect(&:upcase)
        to          =   (to.is_a?(Array) ? to : split_to_array(to)).collect(&:upcase)
        args        =   []
      
        from.each do |f|
          to.each do |t|
            args   <<   "#{f.to_s.upcase}#{t.to_s.upcase}"
          end
        end

        params      =   {symbol: args}
      
        options[:params_encoder]  =   ::Faraday::FlatParamsEncoder
      
        response    =   get(endpoint, params: params, options: options)
        data        =   []
      
        if response && response.is_a?(Array) && response.any?
          response.each do |hash|
            data   <<   ::Revolut::Api::Response::Quote.new(hash)
          end
        end
      
        return data
      end
    
      def split_to_array(string)
        string.include?(",") ? string.split(",") : [string]
      end
    
      def get(path, params: {}, options: {})
        request path, method: :get, params: params, options: options
      end

      def post(path, params: {}, data: {}, options: {})
        request path, method: :post, params: params, data: data, options: options
      end
    
      def patch(path, params: {}, data: {}, options: {})
        request path, method: :patch, params: params, data: data, options: options
      end

      def request(path, method: :get, params: {}, data: {}, options: {})
        check_configuration! if options.fetch(:check_configuration, true)
        
        authenticate      =   options.fetch(:authenticate, true)
        params_encoder    =   options.fetch(:params_encoder, nil)
        user_agent        =   options.fetch(:user_agent, self.configuration.user_agent)
      
        self.headers.merge!(user_agent: user_agent) unless user_agent.to_s.empty?
      
        opts              =   {url: to_uri(path)}
        opts.merge!(request: { params_encoder: params_encoder }) unless params_encoder.nil?
  
        connection        =   Faraday.new(opts) do |builder|
          builder.headers = self.headers
          
          builder.request  :basic_auth, self.configuration.user_id, self.configuration.access_token if authenticate && authable?
          builder.request  :json
          
          builder.response :json
          builder.response :logger if self.configuration.verbose
    
          builder.adapter  :net_http
        end

        response              =   case method
          when :get
            connection.get do |request|
              request.params  =   params if params && !params.empty?
            end&.body
          when :post, :patch
            connection.send(method) do |request|
              request.body    =   data
              request.params  =   params if params && !params.empty?
            end&.body
        end
        
        error?(response)
        
        return response
      end
      
      def authable?
        !self.configuration.user_id.to_s.empty? && !self.configuration.access_token.to_s.empty?
      end
      
      def log(message)
        puts "[Revolut::Api] - #{Time.now}: #{message}" if !message.to_s.empty? && self.configuration.verbose
      end
    
    end
  end
end
