Rails.application.routes.draw do
  get 'sessions/new'
  get '/signup' => 'users#new'
  resources :users, only: [:create]

  get '/sign_in' => 'sessions#new'
  get '/sign_out' => 'sessions#destroy'
  resources :sessions, ony: [:create]

end
