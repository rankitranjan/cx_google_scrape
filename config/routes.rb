require 'sidekiq/web'

Rails.application.routes.draw do

  # API routes
  namespace :api do
    namespace :v1 do
      post 'auth/sign_in', to: 'auth#sign_in'
      get 'keywords', to: 'keywords#index'
      post 'keywords/upload', to: 'keywords#upload'
      get 'keywords/:id', to: 'keywords#detail'
      get 'search', to: 'keywords#search'
    end
  end

  # Web UI routes
  devise_for :users
  resources :keywords do
    get :refresh
    collection do
      get :sample_csv
    end
  end

  get "search", to: "home#index", as: :search_keywords
  get "up" => "rails/health#show", as: :rails_health_check

  # Web Sidekiq UI 
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end  

  root to: "home#index"
end
