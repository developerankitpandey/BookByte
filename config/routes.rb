Rails.application.routes.draw do
  devise_for :users
  
  resources :books, only: [:index, :show, :new, :create, :destroy] do 
    post 'add_to_cart', on: :member
    get '/cart', to: 'books#cart', as: 'cart'

    collection do
      get 'search', to: 'books#search'
    end
  end 

  root 'books#index'
  
  resources :users do
    patch 'become_seller', on: :member
  end
  
end