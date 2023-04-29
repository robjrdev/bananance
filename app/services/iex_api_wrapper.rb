# app/services/iex_api_wrapper.rb
require 'iex-ruby-client'

class IexApiWrapper
  def initialize
    @client = IEX::Api::Client.new
  end

  def quote(symbol)
    @client.quote(symbol)
  end

  def stock_market_list(market_type)
    @client.stock_market_list(market_type)
  end

  def chart(symbol)
    @client.chart(symbol)
  end

  def ref_data_symbols
    @client.ref_data_symbols
  end
end
