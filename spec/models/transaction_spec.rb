require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'create new transaction' do
    it 'can be created with user, transaction type, quantity, price per quantity, symbol' do
      user = User.create(email: 'test@email.com', password: 'password', first_name: 'testname', last_name: 'lastname', status: 'approved')  
      transaction = user.transactions.create(transaction_type: 'buy', quantity: 1,price_per_quantity: 25000, symbol: "BTC")
      expect(transaction).to be_valid
    end
  end
end
