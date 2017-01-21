Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/users/:id', to: 'users#show', as: :user_profile
  get '/users', to: 'users#index', as: :user_index

  # post '/users/:id/microposts', to: 'microposts#create', as: :microposts_create
  get '/users/:id/microposts', to: 'microposts#read', as: :microposts_read
  get '/users/:id/feed', to: 'microposts#feed', as: :user_feed
  # put '/users/:id/microposts', to: 'microposts#update', as: :microposts_update
  # delete '/users/:id/microposts', to: 'microposts#destroy', as: :microposts_destroy
  resources :microposts,   only: [:create, :update, :destroy, :show]
  resource :relationships, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
