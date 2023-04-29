require 'rails_helper'

RSpec.describe UserStock, type: :model do
  let(:user) do
    User.create(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      password_confirmation: 'password123',
    )
  end
  let(:stock) { Stock.create(symbol: 'AAPL', name: 'Apple Inc.') }
  let(:user_stock) do
    UserStock.new(user_id: user.id, stock_id: stock.id, quantity: 10)
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user_stock).to be_valid
    end

    it 'is not valid without a user_id' do
      user_stock.user_id = nil
      expect(user_stock).not_to be_valid
    end

    it 'is not valid without a stock_id' do
      user_stock.stock_id = nil
      expect(user_stock).not_to be_valid
    end
  end
end
