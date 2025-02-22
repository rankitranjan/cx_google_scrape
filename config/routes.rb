Rails.application.routes.draw do
  devise_for :users
  resources :keywords do
    get :refresh
    collection do
      get :sample_csv
    end
  end
  get "search", to: "home#index", as: :search_keywords
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
end
