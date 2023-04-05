class Stock < ApplicationRecord
    belongs_to :user
    validates :user_id, presence: true
    validates :symbol, presence: true
    validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end