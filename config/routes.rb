Rails.application.routes.draw do
  # devise_for :users
  
  resources :books, only: [:index, :show, :new, :create, :destroy] do 
    post 'add_to_cart', on: :member
    delete 'remove_from_cart', on: :member
    
    collection do
      get '/cart', to: 'books#cart', as: 'cart'
      get 'search', to: 'books#search'
    end

    member do 
      post 'add_to_cart', to: 'books#add_to_cart'
      delete 'remove_from_cart', to: 'books#remove_from_cart'
      get 'checkout'
    end 
  end 

  root 'books#index'
  
  resources :users do
    patch 'become_seller', on: :member
  end
  
  devise_for :user,
      controllers: {
         omniauth_callbacks: 'users/omniauth_callbacks'
      }
end