class PagesController < ApplicationController
  before_action :initialize_iex_client


  def dashboard
    if logged_in?
      if current_user.status == "approved"
        render "dashboard"
      elsif current_user.status == "pending"
        redirect_to pending_path
      end
    else
      redirect_to sign_in_path # or some other path if you prefer
    end
  end

  def pending
  end

  def admin
    @users = User.all
    if logged_in? && !current_user.admin
      redirect_to dashboard_path
    end
  end
end
