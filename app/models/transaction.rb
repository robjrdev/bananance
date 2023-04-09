class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock
  enum category: %i[buy sell]

  attr_accessor :amount

  validates :category, :price_per_quantity, :symbol, presence: true
  validates :amount, presence: true
  validates :quantity,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
            }

  def update_stock_quantity(quantity)
    self.buy? ? quantity + self.quantity : quantity - self.quantity
  end
end
