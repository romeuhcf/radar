Rails.application.routes.draw do
  resources :parse_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  resources :ftp_configs
  get 'dashboard/index'

  devise_for :users,  :controllers => {:masquerades => "users/masquerades"}

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  require 'sidekiq/pauser/web'

  authenticate :user, lambda { |u| u.has_role?(:admin) or u.email =='romeu.hcf@gmail.com'} do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end

  authenticate :user do
    resources :route_providers
    resources :inline_sms_requests
    resources :transmission_requests, except: [:new, :update]  do
      resources :steps, only: [:show, :update], controller: 'transmission_request/steps'
      member do
        get :parse_preview
        put :pause
        put :resume
      end
    end
    resources :chat_rooms, only: [:index, :show] do
      post :answer, on: :member
      post :archive, on: :member
      resources :messages, only: [:index, :show]
    end

    resources :transfer_bots do
      member do
        put :activate
        put :deactivate
      end
    end
    resources :api_clients

  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end

  get "/pages/*id" => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'home', as: 'visitor_root'
end
