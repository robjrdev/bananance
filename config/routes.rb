Rails.application.routes.draw do

  get '/dashboard', to: 'pages#dashboard', as: :dashboard
  get '/pending', to: 'pages#pending', as: :pending
  get '/admin', to: 'pages#admin', as: :admin

  get 'sessions/new'
  get '/signup' => 'users#new'
  resources :users, only: [:create]

  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  resources :sessions, ony: [:create, :destroy]

end
