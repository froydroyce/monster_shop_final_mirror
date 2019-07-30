Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration
  resources :users, only: [:create, :update]
  patch '/user/:id', to: 'users#update'
  get '/profile', to: 'users#show'
  get '/profile/addresses', to: 'user/addresses#index'
  post '/profile/addresses', to: 'user/addresses#create'
  get '/profile/addresses/new', to: 'user/addresses#new'
  get '/profile/addresses/:id/edit', to: 'user/addresses#edit', as: 'profile_address_edit'
  delete '/profile/address/:id', to: 'user/addresses#destroy', as: 'profile_address_delete'
  patch '/profile/address/:id', to: 'user/addresses#update', as: 'profile_address_update'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/new', to: 'user/orders#new'
  get '/profile/orders/:id', to: 'user/orders#show'
  patch '/profile/orders/:id', to: 'user/orders#update'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :orders, only: :show
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :coupons, only: [:index, :new, :create, :edit, :update, :destroy]
    patch 'coupon/:id/enable', to: 'coupons#enable', as: 'enable_coupon'
    patch 'coupon/:id/disable', to: 'coupons#disable', as: 'disable_coupon'
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show] do
      resources :addresses, only: :index
    end
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
