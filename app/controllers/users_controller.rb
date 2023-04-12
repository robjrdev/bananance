class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]
  def new
    
    redirect_to dashboard_path if logged_in? && current_user.admin == false
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      NotificationMailer.new_user(@user).deliver_later
      NotificationMailer.pending(@user).deliver_later
      NotificationMailer.admin_notification(@user).deliver_later

      redirect_to sign_in_path
    else
      #flash.now[:notice] = @user.errors.full_messages.to_sentence
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
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def update_status
    @user = User.find(params[:id])

    if @user.status == 'pending'
      @user.update_attribute(:status, 'approved')
      NotificationMailer.approved(@user).deliver_later
      redirect_to admin_path
    elsif @user.update_attribute(:status, 'pending')
      redirect_to admin_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to admin_path
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_path
  end

  def deposit
    @user = User.find(params[:id]) 
  end

  def deposit_money
     @user = current_user
    amount = params[:amount].to_i

    if amount <= 0
      flash[:error] = "Amount must be greater than zero"
      render :deposit
    else
        if @user.update_attribute(:cash, "#{@user.cash += amount}")
          flash[:success] = "Deposit successful! You've deposited $#{amount}"
          redirect_to dashboard_path
        else
          flash[:error] = "Deposit failed"
          render :deposit, status: :unprocessable_entity
        end
    end
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
