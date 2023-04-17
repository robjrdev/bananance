class StocksController < ApplicationController
  before_action :initialize_iex_client, only: %i[search show]

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
      @chart
        .reduce([]) do |init, curr|
          init.push(
            [
              curr['label'],
              curr['open'],
              curr['close'],
              curr['high'],
              curr['low'],
            ],
          )
        end
        .inject({}) do |res, k|
          res[k[0]] = k[1..-1]
          res
        end

    begin
      @quote = @iex_client.quote(@stock.symbol)
    rescue IEX::Errors::SymbolNotFoundError
      flash[:danger] = 'Symbol not found. Please input a valid symbol.'
      render :new
    end
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
      flash[:danger] = 'Symbol not found. Please input a valid symbol.'
      render :new
    end
  end
end
