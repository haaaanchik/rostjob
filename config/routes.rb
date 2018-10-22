Rails.application.routes.draw do
  mount Resque::Server.new, at: '/resque_web'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resource :price, only: :show

  namespace :admin do
    get '/', to: 'dashboards#show'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    resources :staffers
    resources :specializations
    resources :positions
    resources :cities
    resources :companies
    resources :accounts
    resources :price_groups, except: :show
    resources :invoices, only: :index do
      member do
        put :pay
      end
    end
    resources :orders do
      member do
        put :accept
        put :reject
      end
    end
  end

  get '/auth/:provider/callback' => 'oauth#create'

  # devise_for :users, controllers: {
  #   omniauth_callbacks: 'users/omniauth_callbacks',
  #   registrations: 'users/registrations',
  #   sessions: 'users/sessions'
  # }

  resources :users, only: %i[new create update]
  resource :profile, except: %i[show destroy]
  namespace :profile do
    resources :invoices, only: %i[index show create destroy]
    resources :orders, except: %i[create update] do
      member do
        put :hide
        get :pre_publish
        put :publish
        put :complete
        put :cancel
      end
      scope module: :orders do
        resources :proposals, only: %i[index show update] do
          member do
            put :accept
            put :reject
          end
        end
        post 'proposals/:id', to: 'proposals#send_message'
        post 'candidates/hire', to: 'candidates#hire'
        put 'candidates/fire', to: 'candidates#fire'
      end
    end
    post :orders, constraints: ->(req) { req.params.key?(:pre_publish) }, to: 'orders#create_pre_publish'
    post :orders, constraints: ->(req) { req.params.key?(:create) }, to: 'orders#create'
    patch 'orders/:id', constraints: ->(req) { req.params.key?(:pre_publish) }, to: 'orders#update_pre_publish'
    patch 'orders/:id', constraints: ->(req) { req.params.key?(:create) }, to: 'orders#update'
    resources :proposals, only: %i[index show create] do
      member do
        put :cancel
      end
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
  resources :support_messages, only: %i[new create]

  mount ActionCable.server => '/cable'
  root to: 'welcome#index'
end
