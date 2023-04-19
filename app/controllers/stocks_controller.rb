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
      flash[:danger] = 'Symbol not found. Please input a valid symbol.'
      render :new
    end
  end

  def look_up(query)
    #
  end
end
