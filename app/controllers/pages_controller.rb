class PagesController < ApplicationController
  before_action :initialize_iex_client, only: %i[index market dashboard]
  before_action :set_market_list, only: %i[index market dashboard]

  def index
    redirect_to dashboard_path if logged_in?
  end

  def dashboard
    return redirect_to sign_in_path unless logged_in?
    redirect_to_pending_or_admin_path

    @user_stocks = user_stocks_data(UserStock.owned_stocks(current_user))

    @total_estimate = calculate_total_estimate(@user_stocks)
  end

  def pending
    redirect_to dashboard_path if current_user.status != 'pending'
  end

  def wallet
    redirect_to dashboard_path if current_user.status == 'pending'
    @user = @current_user
  end

  def market
    @favorites = user_stocks_data(UserStock.favorite_stocks(current_user))
  end

  def admin
    redirect_to dashboard_path if logged_in? && !current_user.admin
    @users = User.all
    @pending_users =
      @users.select { |user| user.status == 'pending' && user.admin == false }
    @approved_users =
      @users.select { |user| user.status == 'approved' && user.admin == false }
  end

  private

  def redirect_to_pending_or_admin_path
    return redirect_to pending_path if current_user.status == 'pending'
    return redirect_to admin_path if current_user.admin
  end

  def user_stocks_data(user_stocks)
    user_stocks.map do |user_stock|
      stock = Stock.find(user_stock.stock_id)
      quote = @iex_client.quote(stock.symbol)
      {
        company_name: stock.name,
        symbol: stock.symbol,
        quantity: user_stock.quantity,
        latest_price: quote.latest_price,
        change_percent_s: quote.change_percent_s,
      }
    end
  end

  def set_market_list
    @active_market = @iex_client.stock_market_list(:mostactive)

    @gainers_market = @iex_client.stock_market_list(:gainers)

    @top_volume_market = @iex_client.stock_market_list(:iexvolume)

    @losers_market = @iex_client.stock_market_list(:losers)
  end

  def calculate_total_estimate(user_stocks)
    user_stocks.reduce(0) do |sum, user_stock|
      sum + (user_stock[:quantity] * user_stock[:latest_price])
    end
  end
end
