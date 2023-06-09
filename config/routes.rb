Rails
  .application
  .routes
  .draw do
    scope '/trade' do
      get '/:symbol', to: 'stocks#show', as: :stocks_show
      get '/:symbol/buy', to: 'transactions#buy_stock', as: :buy_stock
      get '/:symbol/sell', to: 'transactions#sell_stock', as: :sell_stock
      post '/:symbol',
           to: 'transactions#save_transaction',
           as: :save_transaction
      put '/:symbol', to: 'stocks#favorite', as: :stock_favorite
    end

    get '/portfolio', to: 'stocks#index', as: :stocks_index
    post '/search/', to: 'stocks#search', as: :search_stocks
    get '/stocks/search', to: 'stocks#new', as: :stocks_new
    post '/lookup', to: 'stocks#look_up', as: :lookup_stocks

    get '/wallet', to: 'pages#wallet', as: :wallet
    get '/transactions', to: 'transactions#index', as: :transactions
    get '/markets', to: 'pages#market', as: :market
    get '/dashboard', to: 'pages#dashboard', as: :dashboard
    get '/pending', to: 'pages#pending', as: :pending
    get '/admin', to: 'pages#admin', as: :admin

    get 'sessions/new'
    get '/signup' => 'users#new', :as => :signup
    resources :users, only: %i[create destroy]

    get '/sign_in' => 'sessions#new'
    get '/sign_out' => 'sessions#destroy'
    resources :sessions, only: %i[create destroy]

    patch '/users/:id/update_status',
      to: 'users#update_status',
      as: 'update_user_status'

    get '/users/:id/edit' => 'users#edit', :as => :edit_user
    patch '/users/:id', to: 'users#update', as: :update_user
    resources :fiats do
      member do
        get :deposit
        post :create_deposit
        get :withdraw
        post :create_withdrawal
      end
    end

    root to: 'pages#index'
  end
