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
      render :deposit, status: :unprocessable_entity
    else
      if @user.update_attribute(:cash, @user.cash + amount)
        fiat =
          Fiat.new(transaction_type: 'Deposit', amount: amount, user: @user)
        fiat.save
        flash[:success] = ["Deposit successful! You've deposited $#{amount}"]
        redirect_to dashboard_path
      else
        flash[:error] = ['Deposit failed']
        render :deposit, status: :unprocessable_entity
      end
    end
  end

  def create_withdrawal
    @user = User.find(params[:id])
    amount = params[:amount].to_i

    if amount <= 0
      flash[:error] = ['Amount must be greater than zero']
      render :withdraw, status: :unprocessable_entity
    elsif amount > @user.cash
      flash[:error] = ['Insufficient funds']
      render :withdraw, status: :unprocessable_entity
    else
      if @user.update_attribute(:cash, @user.cash - amount)
        fiat =
          Fiat.new(transaction_type: 'Withdraw', amount: amount, user: @user)
        fiat.save
        flash[:success] = ["Withdraw successful! You've withdrawn $#{amount}"]
        redirect_to dashboard_path
      else
        flash[:error] = ['Withdraw failed']
        render :withdraw, status: :unprocessable_entity
      end
    end
  end
end
