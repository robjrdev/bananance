class FiatsController < ApplicationController
  def deposit
    @user = User.find(params[:id])
  end

  def withdraw
    @user = User.find(params[:id])
  end

  def create_deposit
    @user = User.find(params[:id])
    amount = params[:amount].to_i

    if amount <= 0
      flash[:error] = ['Amount must be greater than zero']
      redirect_to wallet_path
    else
      if Fiat.create_deposit(@user, amount)
        flash[:success] = ["Deposit successful! You've deposited $#{amount}"]
        redirect_to dashboard_path
      else
        flash[:error] = ['Deposit failed']
        redirect_to wallet_path
      end
    end
  end

  def create_withdrawal
    @user = User.find(params[:id])
    amount = params[:amount].to_i

    if amount <= 0
      flash[:error] = ['Amount must be greater than zero']
      redirect_to wallet_path
    elsif Fiat.create_withdrawal(@user, amount)
      flash[:success] = ["Withdraw successful! You've withdrawn $#{amount}"]
      redirect_to dashboard_path
    else
      flash[:error] = ['Insufficient funds']
      redirect_to wallet_path
    end
  end
end
