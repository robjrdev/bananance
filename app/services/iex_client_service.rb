# app/services/iex_client_service.rb
require 'iex-ruby-client'

class IexClientService
  def initialize(api_key)
    IEX::Api.configure do |config|
      config.publishable_token = api_key
      config.endpoint = 'https://cloud.iexapis.com/v1'
    end
  end

  def client
    IEX::Api::Client.new
  end

  def quote(symbol)
    Rails
      .cache
      .fetch("quote_#{symbol}", expires_in: 45.minutes) { client.quote(symbol) }
  end

  def stock_market_list(market_type)
    Rails
      .cache
      .fetch("#{market_type}_market_list", expires_in: 45.minutes) do
        client.stock_market_list(market_type)
      end
  end
end
