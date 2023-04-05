require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "creating new stock" do
    it 'can be created with symbol, user and quantity' do
      user = User.new(email: 'test@email.com', password: 'password', first_name: 'testname', last_name: 'lastname', status: 'approved')
      user.save
      stock = user.stocks.create(symbol: 'BTC', quantity: 1)
      expect(stock).to be_valid
    end
  end
end
