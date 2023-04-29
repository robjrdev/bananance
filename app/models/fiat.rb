class Fiat < ApplicationRecord
  belongs_to :user

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def self.create_deposit(user, amount)
    return false unless user.update_attribute(:cash, user.cash + amount)
    Fiat.create(transaction_type: 'Deposit', amount: amount, user: user)
  end

  def self.create_withdrawal(user, amount)
    return false if amount > user.cash
    return false unless user.update_attribute(:cash, user.cash - amount)
    Fiat.create(transaction_type: 'Withdraw', amount: amount, user: user)
  end
end
