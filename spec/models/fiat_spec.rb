require 'rails_helper'

RSpec.describe Fiat, type: :model do
  let(:user) do
    User.create(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'password123',
      password_confirmation: 'password123',
    )
  end
  let(:fiat) { Fiat.new(transaction_type: 'Deposit', amount: 100, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(fiat).to be_valid
    end

    it 'is not valid without a transaction_type' do
      fiat.transaction_type = nil
      expect(fiat).not_to be_valid
    end

    it 'is not valid without an amount' do
      fiat.amount = nil
      expect(fiat).not_to be_valid
    end

    it 'is not valid with an amount less than or equal to zero' do
      fiat.amount = 0
      expect(fiat).not_to be_valid
    end
  end

  describe '.create_deposit' do
    it 'creates a deposit and updates the user cash' do
      initial_cash = user.cash
      deposit_amount = 100
      deposit = Fiat.create_deposit(user, deposit_amount)

      expect(deposit.transaction_type).to eq('Deposit')
      expect(deposit.amount).to eq(deposit_amount)
      expect(deposit.user).to eq(user)
      expect(user.reload.cash).to eq(initial_cash + deposit_amount)
    end
  end

  describe '.create_withdrawal' do
    it 'creates a withdrawal and updates the user cash' do
      user.update_attribute(:cash, 200)
      initial_cash = user.cash
      withdrawal_amount = 100
      withdrawal = Fiat.create_withdrawal(user, withdrawal_amount)

      expect(withdrawal.transaction_type).to eq('Withdraw')
      expect(withdrawal.amount).to eq(withdrawal_amount)
      expect(withdrawal.user).to eq(user)
      expect(user.reload.cash).to eq(initial_cash - withdrawal_amount)
    end

    it 'does not create a withdrawal if the amount is greater than the user cash' do
      user.update_attribute(:cash, 50)
      withdrawal_amount = 100
      withdrawal = Fiat.create_withdrawal(user, withdrawal_amount)

      expect(withdrawal).to be_falsey
    end
  end
end
