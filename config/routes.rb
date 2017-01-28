Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/users/:id', to: 'users#show', as: :user_profile
  get '/users', to: 'users#index', as: :user_index

  get '/users/:id/microposts', to: 'microposts#read', as: :microposts_read
  get '/users/:id/feed', to: 'microposts#feed', as: :user_feed
  resources :microposts,   only: [:create, :destroy, :show]
  resource :relationships, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
end
