Rails
  .application
  .routes
  .draw do
    resources :stocks, only: %i[index show new], path: '/trade' do
      member do
        get 'buy', to: 'transactions#buy_stock', as: :buy
        get 'sell', to: 'transactions#sell_stock', as: :sell
        post '/', to: 'transactions#save_transaction', as: :save_transaction
        put '/', to: 'stocks#favorite', as: :favorite
      end
      collection do
        post 'search', to: 'stocks#search', as: :search
        post 'lookup', to: 'stocks#look_up', as: :lookup
      end
    end

    resources :transactions, only: :index

    resources :users, only: %i[new create destroy edit update] do
      member do
        patch 'update_status', to: 'users#update_status', as: 'update_status'
      end
    end

    resources :fiats, only: [] do
      member do
        get :deposit
        post :create_deposit
        get :withdraw
        post :create_withdrawal
      end
    end

    resources :sessions, only: %i[new create destroy]

    get '/portfolio', to: 'stocks#index', as: :stocks_index
    get '/wallet', to: 'pages#wallet', as: :wallet
    get '/markets', to: 'pages#market', as: :market
    get '/dashboard', to: 'pages#dashboard', as: :dashboard
    get '/pending', to: 'pages#pending', as: :pending
    get '/admin', to: 'pages#admin', as: :admin

    get '/signup', to: 'users#new', as: :signup
    get '/sign_in', to: 'sessions#new', as: :sign_in
    get '/sign_out', to: 'sessions#destroy', as: :sign_out

    root to: 'pages#index'
  end
