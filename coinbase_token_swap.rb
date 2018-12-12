require "sinatra"
require "sinatra/json"
require "dotenv/load" if File.exists?(".env")
require "httparty"


module CoinbaseTokenSwap
  # AppConfig
  # 
  class AppConfig < Struct.new(:client_id, :client_secret, :client_redirect_url)
    def initialize
      self.client_id = ENV["CLIENT_ID"]
      self.client_secret = ENV["CLIENT_SECRET"]
      self.client_redirect_url = ENV["CLIENT_REDIRECT_URL"]
    end
  end

  # HTTP
  # 
  class HTTP
    include HTTParty
    base_uri "https://api.coinbase.com"
    
    def initialize(config)
      @config = config
    end

    def token(code)
      options = {
        query: {
          grant_type: "authorization_code",
          code: code,
          client_id: @config.client_id,
          client_secret: @config.client_secret,
          redirect_uri: @config.client_redirect_url
        }
      }

      self.class.post("/oauth/token", options)
    end

    def refresh_token(refresh_token)
      options = {
        query: {
          grant_type: "refresh_token",
          client_id: @config.client_id,
          client_secret: @config.client_secret,
          refresh_token: refresh_token
        }
      }

      self.class.post("/oauth/token", options)
    end
  end

  # App
  # 
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    disable :logging if production?
    
    before do
      request.body.rewind
      @body = JSON.parse(request.body.read, symbolize_names: true)
    end
    
    post "/api/token" do      
      config = AppConfig.new
      http = HTTP.new(config).token(@body[:code])
            
      status http.response.code.to_i
      json http.parsed_response
    end

    post "/api/refresh_token" do
      config = AppConfig.new
      http = HTTP.new(config).refresh_token(@body[:refresh_token])

      status http.response.code.to_i
      json http.parsed_response
    end
  end
end
