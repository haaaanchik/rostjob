Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  resources :user_profiles
  resource :profile, only: %i[show edit update]
  namespace :profile do
    resources :orders do
      member do
        put :publish
        put :hide
        put :complete
      end
      resources :proposals, only: %i[index show update]
    end
    resources :proposals
  end

  resources :orders, only: %i[index show]
  resources :recruiters, only: %i[index show]

  root to: 'welcome#index'
end
