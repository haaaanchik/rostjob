Rails.application.routes.draw do
  mount Resque::Server.new, at: '/resque_web'

  # get 'login', to: 'sessions#new'
  # post 'login', to: 'sessions#create'
  # delete 'logout', to: 'sessions#destroy'

  # get '/auth/:provider/callback' => 'sessions#callback'
  get '/oauth/callback/superjob' => 'oauth_callback#superjob'
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get 'secret_reg', to: 'users/registrations#secret_new'
    post 'login', to: 'users/sessions#create'
    delete 'logout', to: 'users/sessions#destroy'
  end
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations'
  }

  resource :price, only: :show

  namespace :api do
    namespace :v1 do
      resource :free_manager, only: :show
      resources :candidates, only: :create
    end
  end

  namespace :admin do
    get 'analytics/export_to_excel'
    get 'analytics/user_action_log'
    get '/', to: 'dashboards#show'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    namespace :superjob do
      resources :queries, except: %i[show] do
        collection do
          put :activate_all
          put :deactivate_all
        end
        member do
          post :copy
          put :activate
          put :deactivate
        end
      end
    end
    namespace :oauth do
      resource :superjob, only: %i[show edit update] do
        member do
          get :download, to: 'superjobs#employee_cvs'
        end
      end
    end
    resources :tickets, only: %i[index show] do
      scope module: :tickets do
        resources :proposal_employees, only: %i[] do
          member do
            put :revoke
            patch :to_inbox
            patch :hire
          end
        end
      end
      member do
        put :close
      end
      scope module: :tickets do
        resources :messages, only: %i[index create]
      end
    end
    resources :proposal_employees, only: %i[index show] do
      member do
        put :revoke
      end
      scope module: :proposal_employees do
        resources :complaints, only: %i[] do
          member do
            put :close
          end
        end
      end
    end
    resources :staffers
    resources :users, only: %i[index edit update]
    resources :clients
    resources :specializations
    resources :positions
    resources :cities
    resources :companies do
      member do
        put :set_active
      end
    end
    resources :accounts
    resources :account_statements, only: %i[index destroy] do
      collection do
        post :upload
        put :handle
      end
    end

    resources :price_groups, except: :show
    get :payment_orders, constraints: ->(req) {req.params.key?(:find)}, to: 'payment_orders#index'
    get :payment_orders, constraints: ->(req) {req.params.key?(:download)}, to: 'payment_orders#download'
    get :payment_orders, to: 'payment_orders#index'

    resources :contractor_invoices, only: %i[index show]
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

  get 'profile/employee_cvs/new_full', to: 'profile/employee_cvs#new_full', as: :new_full_profile_employee_cv
  resource :profile, except: %i[show destroy] do
    member do
      put :set_free
      put :unset_free
    end
  end
  namespace :bots do
    resources :employee_cvs, only: :show
  end
  namespace :profile do
    resources :production_sites do
      scope module: :production_sites do
        resources :order_templates do
          member do
            post :copy
            post :create_order
            put :move
            get :description_info
            get :additional_info
          end
        end
        get '/orders/:state', to: 'orders#index', as: :orders_with_state, constraints: { state: /[_A-Za-z]+/ }
        resources :orders, except: %i[create] do
          member do
            put :hide
            get :pre_publish
            put :publish
            put :complete
            put :cancel
            put :move
            put :update_pre_publish
            put :add_additional_employees
          end
          collection do
            post :add_position
          end
          scope module: :orders do
            resources :candidates, only: %i[show update destroy] do
              member do
                get :hd_correction
                put :hire
                put :fire
                put :disput
                put :reserve
                put :to_inbox
                put :to_interview
                put :transfer
              end
            end
          end
        end
      end
    end

    resources :tickets do
      scope module: :tickets do
        resources :messages, only: %i[index create]
      end
    end
    namespace :tickets do
      resources :appeals, only: %i[new create]
      resources :incidents, only: %i[show new create]
    end
    resources :candidates, only: %i[index show] do
      member do
        put :revoke
      end
    end
    resources :order_templates do
      member do
        post :copy
        post :create_order
      end
    end
    resources :favorites, only: %i[index]
    resources :proposal_employees, only: %i[index show new create] do
      scope module: :proposal_employees do
        resources :complaints, only: %i[index new create]
      end
      member do
        put :to_disput
        put :revoke
        put :correct_interview_date
        get :approve_transfer
      end
    end
    # get 'proposal_employee/:id', to: 'proposal_employee#show'
    resources :invoices, only: %i[index show create destroy]
    resources :answered_orders
    get '/orders/:state', to: 'orders#index', as: :orders_with_state, constraints: { state: /[_A-Za-z]+/ }
    # FIXME: refactor this asap
    resources :orders, except: %i[create] do
      member do
        put :hide
        get :pre_publish
        put :publish
        put :complete
        put :cancel
      end
      collection do
        post :add_position
      end
      scope module: :orders do
        resources :proposals, only: %i[index show update] do
          member do
            put :accept
            put :reject
          end
        end
        post 'proposals/:id', to: 'proposals#send_message'
        # post 'candidates/hire', to: 'candidates#hire'
        # put 'candidates/fire', to: 'candidates#fire'
        resources :candidates, only: %i[index show update destroy] do
          member do
            get :hd_correction
            put :hire
            put :fire
            put :disput
            put :reserve
            put :to_inbox
            put :to_interview
            put :transfer
          end
        end
        # put 'candidates/:id/hire', to: 'candidates#hire'
        # put 'candidates/:id/fire', to: 'candidates#fire'
      end
    end
    # FIXME: refactor this asap
    post :orders, constraints: ->(req) {req.params.key?(:pre_publish)}, to: 'orders#create_pre_publish'
    post :orders, constraints: ->(req) {req.params.key?(:create)}, to: 'orders#create'
    patch 'orders/:id', constraints: ->(req) {req.params.key?(:pre_publish)}, to: 'orders#update_pre_publish'
    patch 'orders/:id', constraints: ->(req) {req.params.key?(:create)}, to: 'orders#update'

    resources :employee_cvs, except: %i[create] do
      member do
        put :to_ready
        put :to_disput
        put :change_status
      end
    end
    post :employee_cvs, constraints: ->(req) { req.params.key?(:pre_new_full) }, to: 'employee_cvs#pre_new_full'
    post :employee_cvs, constraints: ->(req) { req.params.key?(:save) }, to: 'employee_cvs#create_as_ready'
    post :employee_cvs, constraints: ->(req) { req.params.key?(:save_as_draft) }, to: 'employee_cvs#create_as_draft'
    post :employee_cvs, constraints: ->(req) { req.params.key?(:save_as_sent) }, to: 'employee_cvs#create_for_send'

    resources :proposals, only: %i[index show create] do
      member do
        put :cancel
      end
      # scope module: :proposals do
      #   resources :employee_cvs
      # end
    end
    post 'proposals/:id', to: 'proposals#send_message'
    resource :balance, only: :show do
      resources :withdrawal_methods, except: %i[show new create destroy]
      member do
        get :withdrawal, to: 'balances#withdrawal_methods'
        put :withdrawal, to: 'balances#withdrawal'
        get 'contractor_invoice/:id', to: 'balances#contractor_invoice', as: :contractor_invoice
      end
    end
    put :balance, to: 'balances#deposit'
  end

  get '/orders/:customer', to: 'orders#index', as: :orders_by_customer, constraints: { state: /[_A-Za-z]+/ }
  resources :orders, only: %i[index show] do
    member do
      put :manage_fav
      put :add_to_favorites
      put :remove_from_favorites
    end
  end
  resources :recruiters, only: %i[index show]
  resources :support_messages, only: %i[new create]

  get :terms,          to: 'terms#index'
  post 'terms/accept', to: 'terms#accept'

  mount ActionCable.server => '/cable'
  root to: 'welcome#index'
end
