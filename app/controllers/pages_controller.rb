class PagesController < ApplicationController
  before_action :initialize_iex_client

  def index
    #home page
    redirect_to dashboard_path if logged_in?

    @active_market =
      Rails
        .cache
        .fetch('mostactive_stock_market_list', expires_in: 5.minutes) do
          @client.stock_market_list(:mostactive)
        end
  end

  def dashboard
    if logged_in?
      if current_user.status == 'approved'
        render 'dashboard'
      elsif current_user.status == 'pending'
        redirect_to pending_path
      end
    else
      redirect_to sign_in_path
    end
  end

  def pending
    # pending page
    redirect_to dashboard_path if current_user.status != 'pending'
  end

  def admin
    redirect_to dashboard_path if logged_in? && !current_user.admin
    @users = User.all
  end
end
