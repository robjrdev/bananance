class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :quantity,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
            }
  attribute :quantity, default: 0

  def self.owned_stocks(user)
    where(user_id: user.id).where('quantity > ?', 0)
  end

  def self.favorite_stocks(user)
    where(user_id: user.id, favorite: true).where('quantity > ?', 0)
  end

  def stock_data(iex_client)
    iex_client.quote(stock.symbol)
  end
end
