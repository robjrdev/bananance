class StocksController < ApplicationController
  before_action :initialize_iex_client, only: %i[index search show look_up]

  def index
    @owned_stocks = UserStock.owned_stocks(current_user)
    @stocks =
      @owned_stocks.map { |owned_stock| owned_stock.stock_data(@iex_client) }

    @favorite_stocks = UserStock.favorite_stocks(current_user)
    @favorites =
      @favorite_stocks.map do |favorite_stock|
        favorite_stock.stock_data(@iex_client)
      end
  end

  def new; end

  def show
    @stock = Stock.find_by(symbol: params[:symbol])
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
    @shares = @user_stock.try(:quantity) || 0
    @is_favorite = @user_stock.favorite

    @chart_data = @stock.chart_data(@iex_client)

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
      @quote, @stock =
        Stock.find_or_create_from_iex_quote(@iex_client, params[:symbol])
      redirect_to stocks_show_path(@stock.symbol)
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = [e.message]
      render :new
    end
  end

  def look_up
    if params[:query].blank? || params[:query].length < 3
      flash[:error] =
        if params[:query].blank?
          ['Type a symbol or company name']
        else
          ['Too many matches']
        end
      redirect_to market_path and return
    end

    begin
      @filtered_symbols = Stock.filtered_symbols(@iex_client, params[:query])
      @stocks =
        Stock.quotes_from_filtered_symbols(@iex_client, @filtered_symbols)

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

  def favorite
    @stock = Stock.find_by(symbol: params[:symbol])
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
    @user_stock.toggle(:favorite)
    @user_stock.save
    redirect_to stocks_show_path
  end
end
