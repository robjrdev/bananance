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
      if @user.update_attribute(:cash, @user.cash + amount)
        fiat =
          Fiat.new(transaction_type: 'Deposit', amount: amount, user: @user)
        fiat.save
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
    elsif amount > @user.cash
      flash[:error] = ['Insufficient funds']
      redirect_to wallet_path
    else
      if @user.update_attribute(:cash, @user.cash - amount)
        fiat =
          Fiat.new(transaction_type: 'Withdraw', amount: amount, user: @user)
        fiat.save
        flash[:success] = ["Withdraw successful! You've withdrawn $#{amount}"]
        redirect_to dashboard_path
      else
        flash[:error] = ['Withdraw failed']
        redirect_to wallet_path
      end
    end
  end
end
