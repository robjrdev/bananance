class StocksController < ApplicationController
  before_action :initialize_iex_client, only: %i[index search show look_up]

  def index
    @stocks = fetch_stocks_data(UserStock.owned_stocks(current_user))
    @favorites = fetch_stocks_data(UserStock.favorite_stocks(current_user))
  end

  def new; end

  def show
    @stock = Stock.find_by(symbol: params[:symbol])
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
    @shares = @user_stock.try(:quantity) || 0
    @is_favorite = @user_stock.favorite
    @chart_data = @stock.chart_data(@iex_client)
    @quote = fetch_quote(@stock.symbol)
    @transaction = Transaction.new
  end

  def search
    @quote, @stock =
      Stock.find_or_create_from_iex_quote(@iex_client, params[:symbol])
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = [e.message]
    render :new
  else
    redirect_to stocks_show_path(@stock.symbol)
  end

  def look_up
    return handle_invalid_query if invalid_query?

    @filtered_symbols = Stock.filtered_symbols(@iex_client, params[:query])
    @stocks = Stock.quotes_from_filtered_symbols(@iex_client, @filtered_symbols)
  rescue Faraday::ConnectionFailed => e
    flash[:error] = ['Failed to connect to the server. Please try again later.']
    redirect_to market_path
  end

  def favorite
    @stock = Stock.find_by(symbol: params[:symbol])
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
    @user_stock.toggle(:favorite)
    @user_stock.save
    redirect_to stocks_show_path
  end

  private

  def fetch_stocks_data(user_stocks)
    user_stocks.map { |stock| stock.stock_data(@iex_client, stock.quantity) }
  end

  def fetch_quote(symbol)
    @iex_client.quote(symbol)
  rescue IEX::Errors::SymbolNotFoundError
    flash[:danger] = 'Symbol not found. Please input a valid symbol.'
    render :new
  end

  def invalid_query?
    params[:query].blank? || params[:query].length < 3
  end

  def handle_invalid_query
    flash[:error] =
      if params[:query].blank?
        ['Type a symbol or company name']
      else
        ['Too many matches']
      end
    redirect_to market_path
  end
end
