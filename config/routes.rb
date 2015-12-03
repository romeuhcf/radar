Rails.application.routes.draw do
  get 'dashboard/index'

  devise_for :users

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
    resources :transmission_requests do
      resources :steps, only: [:show, :update], controller: 'transmission_request/steps'
      member do
      get :parse_preview
        put :cancel
        put :pause
        put :resume
      end
    end
    resources :chat_rooms, only: [:index, :show] do
      post :answer, on: :member
      post :archive, on: :member
      resources :messages, only: [:index, :show]
    end
  end

  authenticated :user do
    root to: 'dashboard#index', as: 'authenticated_root'
  end

  get "/pages/*id" => 'pages#show', as: :page, format: false
  root to: 'pages#show', id: 'home', as: 'visitor_root'
end
