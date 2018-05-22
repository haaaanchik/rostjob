Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :user_profiles
  resource :profile, only: %i[show edit update]
  namespace :profile do
    resources :orders, except: %i[create update] do
      member do
        put :hide
        get :pre_publish
        put :publish
        put :complete
      end
      scope module: :orders do
        resources :proposals, only: %i[index show update] do
          member do
            put :accept
            put :reject
          end
        end
        post 'proposals/:id', to: 'proposals#send_message'
      end
    end
    post :orders, constraints: -> (req) { req.params.key?(:pre_publish) }, to: 'orders#create_pre_publish'
    post :orders, constraints: -> (req) { req.params.key?(:create) }, to: 'orders#create'
    patch 'orders/:id', constraints: -> (req) { req.params.key?(:pre_publish) }, to: 'orders#update_pre_publish'
    patch 'orders/:id', constraints: -> (req) { req.params.key?(:create) }, to: 'orders#update'
    resources :proposals do
      scope module: :proposals do
        resources :employee_cvs
      end
    end
    post 'proposals/:id', to: 'proposals#send_message'
    resource :balance, only: :show
    put :balance, to: 'balances#deposit'
  end

  resources :orders, only: %i[index show]
  resources :recruiters, only: %i[index show]

  root to: 'welcome#index'
end
