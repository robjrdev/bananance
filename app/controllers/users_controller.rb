class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def new
    redirect_to dashboard_path if logged_in? && current_user.admin == false
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_notifications
      redirect_to sign_in_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_path
    else
      flash[:error] = @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @user = User.find(params[:id])

    if @user.update_status
      redirect_to admin_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to admin_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_path
  end

  private

  def user_params
    params
      .require(:user)
      .permit(
        :email,
        :password,
        :password_confirmation,
        :first_name,
        :last_name,
      )
  end
end
