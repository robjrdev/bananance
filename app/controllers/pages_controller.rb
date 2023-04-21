class PagesController < ApplicationController
  before_action :initialize_iex_client, only: %i[index market dashboard]
  before_action :set_market_list, only: %i[index market dashboard]

  def index
    #home page
    redirect_to dashboard_path if logged_in?
  end

  def dashboard
    return redirect_to sign_in_path unless logged_in?
    return redirect_to pending_path if current_user.status == 'pending'
    return redirect_to admin_path if current_user.admin

    @owned_stocks =
      UserStock.where(user_id: current_user.id).where('quantity > ?', 0)
    @user_stocks =
      @owned_stocks.map do |owned_stock|
        stock = Stock.find(owned_stock.stock_id)
        quote = @iex_client.quote(stock.symbol)
        {
          company_name: stock.name,
          symbol: stock.symbol,
          quantity: owned_stock.quantity,
          latest_price: quote.latest_price,
          change_percent_s: quote.change_percent_s,
        }
      end

    @total_estimate =
      @user_stocks.reduce(0) do |sum, user_stock|
        sum + (user_stock[:quantity] * user_stock[:latest_price])
      end
  end

  def pending
    # pending page
    redirect_to dashboard_path if current_user.status != 'pending'
  end

  def wallet
    # wallet page
    redirect_to dashboard_path if current_user.status == 'pending'

    @user = @current_user
  end

  def market
    # market overview page
  end

  def admin
    redirect_to dashboard_path if logged_in? && !current_user.admin
    @users = User.all
    @pending_users =
      @users.select { |user| user.status == 'pending' && user.admin == false }
    @approved_users =
      @users.select { |user| user.status == 'approved' && user.admin == false }
  end

  def set_market_list
    @active_market = @iex_client.stock_market_list(:mostactive)

    @gainers_market = @iex_client.stock_market_list(:gainers)

    @top_volume_market = @iex_client.stock_market_list(:iexvolume)

    @losers_market = @iex_client.stock_market_list(:losers)
  end
end
