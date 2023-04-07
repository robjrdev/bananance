Rails.application.routes.draw do


  scope '/dashboard' do
    get '/stocks', to: 'stocks#index', as: :stocks_index
  end

  get '/dashboard', to: 'pages#dashboard', as: :dashboard
  get '/pending', to: 'pages#pending', as: :pending
  get '/admin', to: 'pages#admin', as: :admin

  get 'sessions/new'
  get '/signup' => 'users#new'
  resources :users, only: [:create]

  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  resources :sessions, only: [:create, :destroy]

  patch '/users/:id/update_status', to: 'users#update_status', as: 'update_user_status'
  get '/users/:id/edit' => 'users#edit', as: :edit_user
  patch '/users/:id', to: 'users#update', as: :update_user

  root to: 'sessions#new'
end
