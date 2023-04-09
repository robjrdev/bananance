class TransactionsController < ApplicationController
  before_action :initialize_iex_client, except: [:save_transaction]
  before_action :set_stock
  before_action :quote_stock, except: [:save_transaction]

  def buy_stock
    @transaction = Transaction.new
  end

  def sell_stock
    @transaction = Transaction.new
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
  end

  def save_transaction
    @transaction = current_user.transactions.build(transaction_params)

    amount = transaction_params[:amount].to_f
    price_per_quantity = transaction_params[:price_per_quantity].to_f
    quantity = amount / price_per_quantity
    @transaction.quantity = quantity
    @transaction.symbol = @stock.symbol

    @user_stock = current_user.user_stocks.find_or_create_by(stock: @stock)
    updated_quantity = @transaction.update_stock_quantity(@user_stock.quantity)

    if @transaction.save &&
         @user_stock.update(stock: @stock, quantity: updated_quantity)
      redirect_to stocks_show_path
    else
      if @transaction.buy?
        redirect_to :buy_stock
      else
        p @transaction.errors.full_messages
        redirect_to :sell_stock
      end
    end
  end

  private

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol])
  end

  def quote_stock
    @quote = @client.quote(@stock.symbol)
  end

  def transaction_params
    params
      .require(:transaction)
      .permit(:category, :quantity, :price_per_quantity, :stock_id, :amount)
  end
end
