Rails.application.routes.draw do

  root 'users#show'

  # ActiveAdmin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Authentication
  resources :user_sessions, only: [:new, :create, :destroy] do
    collection do
      get :forgot_password
    end
  end
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  get 'logout' => 'user_sessions#destroy'

  post 'oauth/callback' => 'oauths#callback'
  get 'oauth/callback' => 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  # Normal resources
  resources :users, only: [:show, :update] do
    member do
      get :upload_avatar
    end
  end

  resources :websites, only: [:index, :show]
  resources :collections, only: [:index, :show] do
    member do
      resources :folders, only: [:index, :show]
      resources :items, only: [:index]
    end
  end

  get 'items/*id' => 'items#show'
  resources :items, only: [:show]
  get 'folders/*id' => 'folders#show'
  resources :folders, only: [:show]

  resources :static, only: [] do
    collection do
    end
  end
end
