Rails
  .application
  .routes
  .draw do
    scope '/dashboard' do
      get '/stocks', to: 'stocks#index', as: :stocks_index
      get '/stocks/search', to: 'stocks#new', as: :stocks_new
      get '/stocks/:symbol', to: 'stocks#show', as: :stocks_show
      post '/stocks/', to: 'stocks#search', as: :stocks_search
      get '/stocks/:symbol/buy', to: 'transactions#buy_stock', as: :buy_stock
      get '/stocks/:symbol/sell', to: 'transactions#sell_stock', as: :sell_stock
      post '/stocks/:symbol',
           to: 'transactions#save_transaction',
           as: :save_transaction
    end

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

    root to: 'pages#index'
  end
