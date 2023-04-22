class TransactionsController < ApplicationController
  before_action :initialize_iex_client, only: %i[buy_stock sell_stock]
  before_action :set_stock, except: [:index]
  before_action :quote_stock, except: %i[save_transaction index]

  def index
    # transactions page
    if current_user.admin == true
      @transactions = Transaction.all.order(created_at: :desc)
    else
      #
      @transactions = current_user.transactions.order(created_at: :desc)
      @fiats = current_user.fiats
    end
  end

  def buy_stock
    @transaction = Transaction.new
    @user_stock = current_user.user_stocks.find_by(stock: @stock)
    @shares = @user_stock.try(:quantity) || 0
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
      if @transaction.buy?
        flash[:success] = [
          "#{custom_formatter(@transaction.quantity, 6, 'stock', @transaction.symbol, '%n %u')} bananas bought.",
        ]
      elsif @transaction.sell?
        flash[:success] = [
          "#{custom_formatter(@transaction.quantity, 6, 'stock', @transaction.symbol, '%n %u')} bananas sold.",
        ]
      end

      redirect_to stocks_show_path
    else
      flash[:error] = @transaction.errors.full_messages
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
