require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      password_confirmation: 'password123',
    )
  end

  describe 'associations' do
    it 'has many user_stocks' do
      user_stock = UserStock.new
      user.user_stocks << user_stock
      expect(user.user_stocks).to include(user_stock)
    end

    it 'has many stocks through user_stocks' do
      stock = Stock.new
      user_stock = UserStock.new(stock: stock)
      user.user_stocks << user_stock
      expect(user.stocks).to include(stock)
    end

    it 'has many transactions' do
      transaction = Transaction.new
      user.transactions << transaction
      expect(user.transactions).to include(transaction)
    end

    it 'has many fiats' do
      fiat = Fiat.new
      user.fiats << fiat
      expect(user.fiats).to include(fiat)
    end
  end

  describe 'validations' do
    context 'when valid attributes' do
      it 'is valid' do
        expect(user).to be_valid
      end
    end

    context 'when invalid attributes' do
      it 'is invalid without a first_name' do
        user.first_name = nil
        expect(user).not_to be_valid
      end

      it 'is invalid with a long first_name' do
        user.first_name = 'a' * 21
        expect(user).not_to be_valid
      end

      it 'is invalid without a last_name' do
        user.last_name = nil
        expect(user).not_to be_valid
      end

      it 'is invalid with a long last_name' do
        user.last_name = 'a' * 21
        expect(user).not_to be_valid
      end

      it 'is invalid without an email' do
        user.email = nil
        expect(user).not_to be_valid
      end

      it 'is invalid with an incorrect email format' do
        user.email = 'test@.com'
        expect(user).not_to be_valid
      end

      it 'is invalid with a non-unique email' do
        duplicate_user = user.dup
        duplicate_user.email = user.email.upcase
        user.save
        expect(duplicate_user).not_to be_valid
      end

      it 'is invalid without a password' do
        user.password = nil
        expect(user).not_to be_valid
      end

      it 'is invalid with a short password' do
        user.password = 'a' * 4
        expect(user).not_to be_valid
      end

      it 'is invalid without a password_confirmation' do
        user.password_confirmation = nil
        expect(user).not_to be_valid
      end

      it 'is invalid when password and password_confirmation do not match' do
        user.password_confirmation = 'different_password'
        expect(user).not_to be_valid
      end
    end
  end

  describe 'instance methods' do
    before { user.save }

    describe '#password' do
      it 'returns the raw password' do
        expect(user.password).to eq('password123')
      end
    end

    describe '#password=' do
      it 'sets the password_digest' do
        expect(user.password_digest).not_to be_nil
      end
    end

    describe '#is_password?' do
      it 'returns true if raw password matches the digest' do
        expect(user.is_password?('password123')).to be true
      end

      it 'returns false if raw password does not match the digest' do
        expect(user.is_password?('wrong_password')).to be false
      end
    end

    describe '#is_admin?' do
      context 'when user is admin' do
        before { user.update(admin: true) }
        it { expect(user.is_admin?).to be true }
      end

      context 'when user is not admin' do
        it { expect(user.is_admin?).to be false }
      end
    end
  end
end
