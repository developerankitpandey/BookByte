Rails.application.routes.draw do
  devise_for :users
  
  resources :books, only: [:index, :show, :new, :create]

  root 'books#index'
  
  resources :users do
    patch 'become_seller', on: :member
  end
end