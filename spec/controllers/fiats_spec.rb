require 'rails_helper'

RSpec.describe FiatsController, type: :controller do
  describe 'POST #create_deposit' do
    let(:user) do
        User.create(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          password_confirmation: 'password123',
        )
      end
      def login(user)
        session[:user_id] = user.id
      end
      before do
        login(user)
      end

    context 'with valid parameters' do
      it 'creates a deposit and redirects to dashboard' do
        post :create_deposit, params: { id: user.id, amount: 100 }
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:success]).to eq(["Deposit successful! You've deposited $100"])
        expect(user.reload.cash).to eq(100)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error and redirects to wallet' do
        post :create_deposit, params: { id: user.id, amount: -100 }
        expect(response).to redirect_to(wallet_path)
        expect(flash[:error]).to eq(['Amount must be greater than zero'])
      end

      it 'returns an error and redirects to wallet' do
        allow(Fiat).to receive(:create_deposit).and_return(false)
        post :create_deposit, params: { id: user.id, amount: 100 }
        expect(response).to redirect_to(wallet_path)
        expect(flash[:error]).to eq(['Deposit failed'])
      end
    end
  end

  describe 'POST #create_withdrawal' do 
    let(:user) do
        User.create(
          first_name: 'John',
          last_name: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          cash: 200,
        )
      end
      def login(user)
        session[:user_id] = user.id
      end
      before do
        login(user)
      end
    context 'with valid parameters' do
      it 'creates a withdrawal and redirects to dashboard' do
        post :create_withdrawal, params: { id: user.id, amount: 100 }
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:success]).to eq(["Withdraw successful! You've withdrawn $100"])
        expect(user.reload.cash).to eq(100)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error and redirects to wallet' do
        post :create_withdrawal, params: { id: user.id, amount: -100 }
        expect(response).to redirect_to(wallet_path)
        expect(flash[:error]).to eq(['Amount must be greater than zero'])
      end

      it 'returns an error and redirects to wallet' do
        allow(Fiat).to receive(:create_withdrawal).and_return(false)
        post :create_withdrawal, params: { id: user.id, amount: 300 }
        expect(response).to redirect_to(wallet_path)
        expect(flash[:error]).to eq(['Insufficient funds'])
      end
    end
  end
end
