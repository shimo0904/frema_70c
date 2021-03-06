Rails.application.routes.draw do
  devise_for :users, controllers: {
  omniauth_callbacks: 'users/omniauth_callbacks',
  registrations: 'users/registrations'
  }
  
  get '/searches/detail_search', to: 'searches#detail_search'
  
  devise_scope :user do
    get  'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end
  
  $date = Time.now.in_time_zone('Tokyo').to_s
  
  root "items#index"

  resources :categories, only: [:index] do
    member do
      get 'parent'
      get 'child'
      get 'grandchild'
    end
  end

  resources :items do
    collection do
      get "set_images"
      get 'get_category_children', defaults: { format: 'json' }
      get 'get_category_grandchildren', defaults: { format: 'json' }
    end
    
    member do
      get "purchase"
      get "done"
      post "pay"
    end

    resources :comments, only:[:create,:destroy]
    
  end
  
  resources  :items do
    resources :favorites , only: [:index, :create, :destroy]
  end


  resources :users, only: [:new, :show, :edit, :update] do
    collection do
      get "signin"
    end
  end
  
  
  resources :users,     only: [:show, :index, :edit, :update] do
    get 'edit_detail', to: 'users#edit_detail'
    patch 'update_detail', to: 'users#update_detail'
  end


  resources :addresses, only:[:edit, :update] do
    get 'edit', to:'addresses#edit'
    patch 'update', to: 'addresses#update'
  end  
  
  resources :mypage, only: [:index, :show, :new, :edit, :create] do
    collection do
      get "logout"
    end   
  end

  resources :creditcards, only:[:index, :new, :create, :destroy, :show] do
    member do
      post 'pay'
    end
  end

  resources :searches, only:[:index] 
    
  


end

