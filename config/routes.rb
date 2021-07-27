Rails.application.routes.draw do
  resources :jobs
  resources :quotes
  resources :requests
  root 'home#index'
  get '/search', to: 'home#search', as: 'search'
  resources :profiles
  resources :listings
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
