class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  enum category: %i[buy sell]

  attr_accessor :amount

  after_commit :update_cash_amount

  validates :category, :price_per_quantity, :symbol, presence: true
  validates :amount, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.transactions_and_fiats(user)
    if user.admin
      transactions = Transaction.all.order(created_at: :desc)
      fiats = Fiat.all.order(created_at: :desc)
    else
      transactions = user.transactions.order(created_at: :desc)
      fiats = user.fiats.order(created_at: :desc)
    end

    return transactions, fiats
  end

  def self.prepare_buy_sell_stock(user, stock)
    transaction = Transaction.new
    user_stock = user.user_stocks.find_or_create_by(stock: stock)
    shares = user_stock.quantity

    return transaction, shares
  end

  def self.save_transaction(params, user, stock)
    transaction = user.transactions.build(params)

    amount = params[:amount].to_f
    price_per_quantity = params[:price_per_quantity].to_f
    quantity = amount / price_per_quantity
    transaction.quantity = quantity
    transaction.symbol = stock.symbol

    user_stock = user.user_stocks.find_or_create_by(stock: stock)
    updated_quantity = transaction.update_stock_quantity(user_stock.quantity)

    if transaction.save &&
         user_stock.update(stock: stock, quantity: updated_quantity)
      return transaction, nil
    else
      error_message = transaction.errors.full_messages
      return transaction, error_message
    end
  end

  def update_stock_quantity(new_quantity)
    self.buy? ? new_quantity + self.quantity : new_quantity - self.quantity
  end

  def update_cash_amount
    @price = price_per_quantity * quantity

    if self.buy?
      user.update(cash: (user.cash - @price))
    else
      user.update(cash: (user.cash + @price))
    end
  end

  def display_success_message
    action = self.buy? ? 'bought' : 'sold'
    message = [
      "#{custom_formatter(self.quantity, 6, 'stock', self.symbol, '%n %u')} bananas #{action}.",
    ]
    return message
  end
end
