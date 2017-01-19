Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/user', to: 'users#show', as: :user_root
  get '/users', to: 'users#index', as: :user_index

  # post '/users/:id/microposts', to: 'microposts#create', as: :microposts_create
  get '/users/:id/microposts', to: 'microposts#read', as: :microposts_read
  # put '/users/:id/microposts', to: 'microposts#update', as: :microposts_update
  # delete '/users/:id/microposts', to: 'microposts#destroy', as: :microposts_destroy
  resources :microposts, only: [:create, :update, :destroy, :show]
end
