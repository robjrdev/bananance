class Transaction < ApplicationRecord  
    belongs_to :user
    belongs_to :stock
    enum transaction_type: [ :buy, :sell ]
    
    validates :transaction_type, :quantity, :price_per_quantity, :symbol, presence: true
    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end