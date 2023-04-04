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
        redirect_to signup_path
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
