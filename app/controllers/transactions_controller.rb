class TransactionsController < ApplicationController
  before_action :initialize_iex_client, only: %i[buy_stock sell_stock]
  before_action :set_stock, except: [:index]
  before_action :quote_stock, except: %i[save_transaction index]

  def index
    @transactions, @fiats = Transaction.transactions_and_fiats(current_user)
  end

  def buy_stock
    @transaction, @shares =
      Transaction.prepare_buy_sell_stock(current_user, @stock)
  end

  def sell_stock
    @transaction, @user_stock =
      Transaction.prepare_buy_sell_stock(current_user, @stock)
  end

  def save_transaction
    @transaction, @error_message =
      Transaction.save_transaction(transaction_params, current_user, @stock)

    if error_message.nil?
      flash[:success] = @transaction.display_success_message
      redirect_to stocks_show_path
    else
      flash[:error] = @error_message
      redirect_to stocks_show_path
    end
  end

  private

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol])
  end

  def quote_stock
    @quote = @iex_client.quote(@stock.symbol)
  end

  def transaction_params
    params
      .require(:transaction)
      .permit(:category, :quantity, :price_per_quantity, :stock_id, :amount)
  end
end
