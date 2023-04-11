class SessionsController < ApplicationController
  skip_before_action :require_login
  def new
    redirect_to dashboard_path if logged_in?
    @user = User.new
  end

  def create
    # look up user in the database
    @user = User.find_by(email: user_params[:email])

    # check if user exists and password is correct
    if user_params[:email].presence && user_params[:password].presence
      if @user && @user.is_password?(user_params[:password])
        session[:user_id] = @user.id
        if @user.admin
          redirect_to admin_path
        elsif @user.status == 'pending'
          redirect_to pending_path
        else
          redirect_to dashboard_path
        end
      else
        flash.now[:notice] = 'Email or password is incorrect'
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:notice] = 'Email or password should not be empty'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end
end
