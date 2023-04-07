class Stock < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions
    has_many :user_stocks, dependent: :delete_all

    validates :symbol, :name, presence: true
    validates :symbol, uniqueness: true
end