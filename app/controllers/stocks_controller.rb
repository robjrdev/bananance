class StocksController < ApplicationController
  before_action :initialize_iex_client, only: %i[search show, look_up]

  def index
    #
  end

  def new
    #
  end

  def show
    #
    @stock = Stock.find_by(symbol: params[:symbol])
    @user_stock = current_user.user_stocks.find_by(stock: @stock)
    @shares = @user_stock.try(:quantity) || 0

    # chart part
    @chart = @iex_client.chart(@stock.symbol)

    @chart_data =
      @chart.each_with_object({}) do |data_point, hash|
        hash[data_point['label']] = [
          data_point['open'],
          data_point['close'],
          data_point['high'],
          data_point['low'],
        ]
      end

    begin
      @quote = @iex_client.quote(@stock.symbol)
    rescue IEX::Errors::SymbolNotFoundError
      flash[:danger] = 'Symbol not found. Please input a valid symbol.'
      render :new
    end

    @transaction = Transaction.new
  end

  def search
    begin
      @quote = @iex_client.quote(params[:symbol])

      @stock = Stock.find_by(symbol: params[:symbol])

      if @stock.nil?
        @stock = Stock.new
        @stock.symbol = @quote.symbol
        @stock.name = @quote.company_name
        @stock.save
      end

      redirect_to stocks_show_path(@stock.symbol)
    rescue IEX::Errors::SymbolNotFoundError
      flash[:error] = ['Symbol not found. Please input a valid symbol.']
      render :new
    end
  end

  def look_up
    if params[:query] == '' || params[:query].nil? || params[:query].empty?
      flash[:error] = ['Type a symbol or company name']
      redirect_to market_path and return
    elsif params[:query].length < 3
      flash[:error] = ['Too many matches']
      redirect_to market_path and return
    end

    #
    # debugger
    begin
      @all_symbols ||= @iex_client.ref_data_symbols
      @filtered_symbols =
        @all_symbols.select do |symbol|
          symbol.symbol.downcase.include?(params[:query].downcase) ||
            symbol.name.downcase.include?(params[:query].downcase)
        end
      @stocks =
        @filtered_symbols.map { |symbol| @iex_client.quote(symbol.symbol) }

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
                   turbo_stream.replace(
                     'stocks-results-table',
                     partial: 'look_up_table',
                     locals: {
                       stocks: @stocks,
                     },
                   )
        end
      end
    rescue Faraday::ConnectionFailed => e
      flash[:error] = [
        'Failed to connect to the server. Please try again later.',
      ]
      redirect_to market_path
    end
  end
end
