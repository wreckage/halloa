Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/user/:id', to: 'users#show', as: :profile
end
