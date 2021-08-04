Rails.application.routes.draw do
  root 'home#index'
  get '/search', to: 'home#search', as: 'search'
  get '/coming_soon', to: 'home#coming_soon', as: 'coming'
  resources :profiles, except: [:index, :destroy]
  resources :listings
  resources :reviews, only: [:edit, :update]
  resources :quotes, :jobs, except: [:new, :edit, :destroy]
  resources :requests, only: [:create, :update]
  devise_for :users
  post 'payment/page', to: 'payments#create', as: 'payment'
  get 'payment/cancel', to: 'payments#cancel', as: 'payment_cancel'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
