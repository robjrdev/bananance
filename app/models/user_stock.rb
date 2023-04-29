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

  def stock_data(iex_client, quantity = nil)
    begin
      quote = iex_client.quote(stock.symbol)
      {
        company_name: stock.name,
        symbol: stock.symbol,
        quantity: quantity,
        latest_price: quote.latest_price,
        change_percent_s: quote.change_percent_s,
      }
    rescue StandardError => e
      Rails
        .logger.error "Error fetching stock data for #{stock.symbol}: #{e.message}"
      nil
    end
  end
end
