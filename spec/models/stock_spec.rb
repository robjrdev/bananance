# spec/models/stock_spec.rb
require 'rails_helper'

RSpec.describe Stock, type: :model do
  let(:iex_client) { instance_double('IexClientService') }
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

  describe '.find_or_create_from_iex_quote' do
    let(:quote) { OpenStruct.new(symbol: 'AAPL', company_name: 'Apple Inc.') }

    before do
      allow(iex_client).to receive(:quote).with('AAPL').and_return(quote)
    end

    it 'returns an existing stock and quote if the stock is already in the database' do
      result_quote, result_stock =
        Stock.find_or_create_from_iex_quote(iex_client, 'AAPL')
      expect(result_quote).to eq(quote)
      expect(result_stock.symbol).to eq(stock.symbol)
      expect(result_stock.name).to eq(stock.name)
    end

    it 'creates a new stock and returns it along with the quote if the stock is not in the database' do
      Stock.delete_all
      result = Stock.find_or_create_from_iex_quote(iex_client, 'AAPL')
      new_stock = Stock.first
      expect(result).to eq([quote, new_stock])
    end
  end

  describe '.filtered_symbols' do
    let(:symbols) do
      [
        OpenStruct.new(symbol: 'AAPL', name: 'Apple Inc.'),
        OpenStruct.new(symbol: 'GOOGL', name: 'Alphabet Inc.'),
      ]
    end

    before do
      allow(iex_client).to receive(:ref_data_symbols).and_return(symbols)
    end

    it 'returns filtered symbols based on the query' do
      result = Stock.filtered_symbols(iex_client, 'AAPL')
      expect(result).to eq([symbols.first])
    end
  end

  describe '.quotes_from_filtered_symbols' do
    let(:symbols) do
      [
        OpenStruct.new(symbol: 'AAPL', name: 'Apple Inc.'),
        OpenStruct.new(symbol: 'GOOGL', name: 'Alphabet Inc.'),
      ]
    end

    let(:quotes) do
      [
        OpenStruct.new(symbol: 'AAPL', company_name: 'Apple Inc.'),
        OpenStruct.new(symbol: 'GOOGL', company_name: 'Alphabet Inc.'),
      ]
    end

    before do
      allow(iex_client).to receive(:quote).with('AAPL').and_return(quotes.first)
      allow(iex_client).to receive(:quote).with('GOOGL').and_return(quotes.last)
    end

    it 'returns quotes for the given symbols' do
      result = Stock.quotes_from_filtered_symbols(iex_client, symbols)
      expect(result).to eq(quotes)
    end
  end

  describe '#chart_data' do
    let(:chart) do
      [
        {
          'label' => '09:30 AM',
          'open' => 100,
          'close' => 110,
          'high' => 120,
          'low' => 90,
        },
        {
          'label' => '10:00 AM',
          'open' => 110,
          'close' => 120,
          'high' => 130,
          'low' => 100,
        },
      ]
    end

    before do
      allow(iex_client).to receive(:chart).with('AAPL').and_return(chart)
    end

    it 'returns chart data for the stock' do
      result = stock.chart_data(iex_client)
      expected_data = {
        '09:30 AM' => [100, 110, 120, 90],
        '10:00 AM' => [110, 120, 130, 100],
      }
      expect(result).to eq(expected_data)
    end
  end
end
