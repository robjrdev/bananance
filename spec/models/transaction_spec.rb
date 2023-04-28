# spec/models/transaction_spec.rb
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) do
    User.create(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      cash: 10_000,
    )
  end
  let(:stock) { Stock.create(symbol: 'AAPL', name: 'Apple Inc.') }
  let(:transaction) do
    Transaction.new(
      user: user,
      stock: stock,
      category: :buy,
      price_per_quantity: 150,
      symbol: 'AAPL',
      quantity: 10,
      amount: 1500,
    )
  end

  describe 'associations' do
    it 'belongs to user' do
      expect(transaction.user).to eq(user)
    end

    it 'belongs to stock' do
      expect(transaction.stock).to eq(stock)
    end
  end

  describe 'validations' do
    context 'when valid attributes' do
      it 'is valid' do
        expect(transaction).to be_valid
      end
    end

    context 'when invalid attributes' do
      it 'is invalid without a category' do
        transaction.category = nil
        expect(transaction).not_to be_valid
      end

      it 'is invalid without a price_per_quantity' do
        transaction.price_per_quantity = nil
        expect(transaction).not_to be_valid
      end

      it 'is invalid without a symbol' do
        transaction.symbol = nil
        expect(transaction).not_to be_valid
      end

      it 'is invalid without a quantity' do
        transaction.quantity = nil
        expect(transaction).not_to be_valid
      end

      it 'is invalid with a quantity less than or equal to 0' do
        transaction.quantity = 0
        expect(transaction).not_to be_valid
      end
    end
  end

  describe 'custom methods' do
    before { transaction.save }

    describe '.transactions_and_fiats' do
      let(:fiat) { Fiat.create(user: user, amount: 1000) }
      context 'when user is admin' do
        before { user.update(admin: true) }
        it 'returns all transactions and fiats' do
          transactions, fiats = Transaction.transactions_and_fiats(user)
          expect(transactions).to include(transaction)
          expect(fiats).to include(fiat)
        end
      end

      context 'when user is not admin' do
        it 'returns user transactions and fiats' do
          transactions, fiats = Transaction.transactions_and_fiats(user)
          expect(transactions).to include(transaction)
          expect(fiats).to include(fiat)
        end
      end
    end

    describe '.prepare_buy_sell_stock' do
      it 'returns a new transaction and shares' do
        new_transaction, shares =
          Transaction.prepare_buy_sell_stock(user, stock)
        expect(new_transaction).to be_a_new(Transaction)
        expect(shares).to eq(0)
      end
    end

    describe '.save_transaction' do
      let(:params) do
        {
          category: :sell,
          price_per_quantity: 150,
          amount: 1500,
          quantity: 10,
          stock_id: stock.id,
        }
      end
      context 'when transaction and user_stock save successfully' do
        it 'returns the transaction' do
          saved_transaction, error_messages =
            Transaction.save_transaction(params, user, stock)

          expect(saved_transaction).to be_a(Transaction)
          expect(error_messages).to be_empty
        end
      end

      context 'when transaction or user_stock fails to save' do
        it 'returns errors' do
          params[:price_per_quantity] = -1
          saved_transaction, error_messages =
            Transaction.save_transaction(params, user, stock)
          expect(error_messages).not_to be_empty
        end
      end
    end

    describe '#update_stock_quantity' do
      context 'when category is buy' do
        it 'returns updated quantity after buying' do
          updated_quantity = transaction.update_stock_quantity(20)
          expect(updated_quantity).to eq(30)
        end
      end

      context 'when category is sell' do
        it 'returns updated quantity after selling' do
          transaction.category = :sell
          updated_quantity = transaction.update_stock_quantity(20)
          expect(updated_quantity).to eq(10)
        end
      end
    end

    describe '#update_cash_amount' do
      context 'when category is buy' do
        it 'updates user cash after buying' do
          expect { transaction.update_cash_amount }.to change {
            user.reload.cash
          }.by(-1500)
        end
      end

      context 'when category is sell' do
        it 'updates user cash after selling' do
          transaction.category = :sell
          transaction.quantity = 5
          transaction.save
          expect { transaction.update_cash_amount }.to change {
            user.reload.cash
          }.by(750)
        end
      end
    end

    describe '#display_success_message' do
      context 'when category is buy' do
        it 'returns a success message for buying stock' do
          message = transaction.display_success_message
          expect(message).to eq(['10.000000 AAPL bananas bought.'])
        end
      end

      context 'when category is sell' do
        it 'returns a success message for selling stock' do
          transaction.category = :sell
          message = transaction.display_success_message
          expect(message).to eq(['10.000000 AAPL bananas sold.'])
        end
      end
    end
  end
end
