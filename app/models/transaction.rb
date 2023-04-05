class Transaction < ApplicationRecord
    belongs_to :user
    validates :user_id, presence: true
    validates :symbol, presence: true
    validates :transaction_type, presence: true
    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :price_per_quantity, presence: true
end