Rails.application.routes.draw do
  devise_for :users
  get 'homes/index'
  resources :routines, only: [:new, :create, :edit, :update, :destroy, :show]
  
  resources :routines do
    member do
      patch :update_status
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "homes#index"
end
