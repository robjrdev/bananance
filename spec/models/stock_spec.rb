# spec/models/stock_spec.rb
require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:stock) { Stock.new(symbol: 'AAPL', name: 'Apple Inc.') }

  describe 'associations' do
    it 'has many transactions' do
      transaction = Transaction.new
      stock.transactions << transaction
      expect(stock.transactions).to include(transaction)
    end

    it 'has many users through transactions' do
      user = User.new
      transaction = Transaction.new(user: user)
      stock.transactions << transaction
      expect(stock.users).to include(user)
    end

    it 'has many user_stocks' do
      user_stock = UserStock.new
      stock.user_stocks << user_stock
      expect(stock.user_stocks).to include(user_stock)
    end
  end

  describe 'validations' do
    context 'when valid attributes' do
      it 'is valid' do
        expect(stock).to be_valid
      end
    end

    context 'when invalid attributes' do
      it 'is invalid without a symbol' do
        stock.symbol = nil
        expect(stock).not_to be_valid
      end

      it 'is invalid without a name' do
        stock.name = nil
        expect(stock).not_to be_valid
      end

      it 'is invalid with a non-unique symbol' do
        duplicate_stock = stock.dup
        stock.save
        expect(duplicate_stock).not_to be_valid
      end
    end
  end
end
