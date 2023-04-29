# app/services/iex_client_service.rb
class IexClientService
  def initialize
    @api_wrapper = IexApiWrapper.new
  end

  def quote(symbol)
    Rails
      .cache
      .fetch("quote_#{symbol}", expires_in: 24.hours) do
        @api_wrapper.quote(symbol)
      end
  end

  def stock_market_list(market_type)
    Rails
      .cache
      .fetch("#{market_type}_market_list", expires_in: 24.hours) do
        @api_wrapper.stock_market_list(market_type)
      end
  end

  def chart(symbol)
    Rails
      .cache
      .fetch("chart_#{symbol}", expires_in: 24.hours) do
        @api_wrapper.chart(symbol)
      end
  end

  def ref_data_symbols
    Rails
      .cache
      .fetch('ref_data_symbols', expires_in: 24.hours) do
        @api_wrapper.ref_data_symbols
      end
  end
end
