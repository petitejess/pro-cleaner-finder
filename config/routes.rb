Rails.application.routes.draw do
  root 'home#index'
  get '/search', to: 'home#search', as: 'search'
  resources :profiles
  resources :listings
  resources :reviews
  resources :jobs
  resources :quotes
  resources :requests
  devise_for :users
  post 'payment/page', to: 'payments#create', as: 'payment'
  get 'payment/cancel', to: 'payments#cancel', as: 'payment_cancel'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
