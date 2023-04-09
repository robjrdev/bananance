class TransactionsController < ApplicationController
  before_action :initialize_iex_client, :set_stock

  def buy_stock
    @transaction = Transaction.new
  end

  def sell_stock
    @transaction = Transaction.new
    @user_stock = current_user.user_stocks.find_or_initialize_by(stock: @stock)
  end

  private

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol])
  end

  def quote_stock
    @quote = @client.quote(@stock.symbol)
  end
end
