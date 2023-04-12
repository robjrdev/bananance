class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  enum category: %i[buy sell]

  attr_accessor :amount

  after_commit :update_cash_amount

  validates :category, :price_per_quantity, :symbol, presence: true
  validates :amount, presence: true
  validates :quantity,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
            }

  def update_stock_quantity(new_quantity)
    self.buy? ? new_quantity + self.quantity : new_quantity - self.quantity
  end

  def update_cash_amount
    @price = price_per_quantity * quantity

    if self.buy?
      user.update_attribute(:cash, (user.cash - @price))
    else
      user.update_attribute(:cash, (user.cash + @price))
    end
  end
end
