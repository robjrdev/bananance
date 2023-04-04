class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    #look up user in the database
    @user = User.find_by(email: user_params[:email])
    #Compare their password
    if user_params[:email].presence && user_params[:password].presence
      if @user && @user.is_password?(user_params[:password])
        session[:user_id] = @user.id
        if @user.isadmin
        redirect_to admin_path
        elsif @user.status == 'pending'
          redirect_to pending_path
        else
          redirect_to dashboard_path
        end
      else
        flash.now[:notice] = "Email or password is incorrect"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:notice] = "Email or password should not be empty"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end
end
