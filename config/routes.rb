Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  resources :user_profiles
  resource :profile, only: %i[show edit update]
  namespace :profile do
    resources :orders
    resources :proposals
  end

  root to: 'welcome#index'
end
