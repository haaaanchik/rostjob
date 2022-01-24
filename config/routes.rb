Rails.application.routes.draw do
  mount Api::Base => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  mount Resque::Server.new, at: '/resque_web'
  get '/pages/*id' => 'pages#show', as: :page, format: false

  get '/oauth/callback/superjob', to: 'oauth_callback#superjob'
  get '/oauth/callback/zarplata', to: 'oauth_callback#zarplata'

  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    get :contractor_info, to: 'users/registrations#contractor_info'
    get :new_contractor, to: 'users/registrations#new_contractor'
    get :new_customer, to: 'users/registrations#new_customer'
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

  scope module: :landing_pages do
    get :industrial
    get :freelance
    get :industry
    %w[freelance industrial].each do |space|
      scope space do
        get :about_company
        get :contacts
      end
    end
    scope :industrial do
      get 'professions/:slug', action: 'professions', as: :professions
    end
    post :request_call
    get :services
  end

  resource :price, only: :show

  namespace :profile do
    resources :settings, only: %i[index update]
  end

  namespace :admin do
    namespace :zarplata do
      get 'order/:id', action: 'order', as: :order
      get :authorization
      post :publish
      get :refresh_token
    end

    get '/', to: 'dashboards#show'
    root to: 'dashboards#show'

    namespace :analytics do
      get :export_to_excel
      get :user_action_log
      get :orders_info
    end

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
    resources :careerists, except: %i[show] do
      collection do
        put :activate_all
        put :deactivate_all
        get :run_job
      end
      member do
        post :copy
        put :activate
        put :deactivate
      end
    end
    resources :tickets, only: %i[index show] do
      scope module: :tickets do
        resources :proposal_employees, only: %i[] do
          member do
            put :revoke
            patch :to_interview
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
    resources :proposal_employees, only: :index do
      member do
        put :revoke
        put :hire
        put :approve
        put :paid
        put :approve_act
      end
      collection do
        get :approval_list
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
    resources :users, only: %i[index edit update] do
      member do
        put :withdrawal
        put :change_manager_status
      end
    end
    resources :specializations
    resources :positions
    resources :geo_cities
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
    resources :proposal_employee_invoices, only: %i[index show]
    resources :invoices, only: %i[index destroy] do
      member do
        put :pay
      end
    end
    resources :tinkoff_invoices, only: %i[index]

    resources :orders do
      member do
        put :accept
        put :reject
      end
    end

    resources :mails, only: %i[new create] do
      collection do
       get :send_mail_order_wait_payment
       get :send_mail_invoice_wait_payment
       get :send_mail_employee_sent
       get :send_notify_interview
      end
    end

    resources :trello, only: %i[index] do
      collection do
        get :export_xlsx
      end
    end

    resources :setting_offers

    resources :production_sites, except: %i[new create]
    resources :employee_cvs, only: %i[edit update]
  end

  resource :profile, only: %i[show edit update] do
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
        resources :order_templates, except: %i[edit show] do
          member do
            put :move
            put :save_name
            get :first_step
            get :second_step
            get :third_step
          end
          collection do
            delete :destroy_array
            post :copy
          end
        end
        resources :orders, only: %i[index update show] do
          member do
            put :hide
            get :pre_publish
            put :publish
            put :complete
            put :cancel
            put :move
            put :update_pre_publish
            put :add_additional_employees
            get :first_step
            get :second_step
            get :third_step
          end
          collection do
            post :add_position
            delete :destroy
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
      resources :appeals, only: %i[create]
      resources :incidents, only: %i[update show new create] do
        member do
          put :hire
          put :revoke
          put :inbox
          put :interview
          put :failed_interview
        end
      end
    end
    resources :candidates, only: %i[index show] do
      member do
        put :revoke
        put :approve_act
        put :comment
      end
      collection do
        get :approval_list
        put :approve_all_acts
      end
    end
    resources :order_templates do
      member do
        post :copy
        post :create_order
      end
    end
    resources :favorites, only: %i[index] do
      collection do
        get :search_orders
      end
    end
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

    resources :invoices, only: %i[index show create destroy] do
      member do
        get :check_invoice_tinkoff
      end
    end

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
            put :to_approved
            put :transfer
            put :hire_in_compleated_order
          end
        end
        # put 'candidates/:id/hire', to: 'candidates#hire'
        # put 'candidates/:id/fire', to: 'candidates#fire'
      end
    end
    # FIXME: refactor this asap
    patch 'orders/:id', constraints: ->(req) {req.params.key?(:pre_publish)}, to: 'orders#update_pre_publish'
    patch 'orders/:id', constraints: ->(req) {req.params.key?(:create)}, to: 'orders#update'

    resources :employee_cvs, except: %i[create] do
      member do
        put :to_ready
        put :to_disput
        put :change_status
        put :reset_reminder
      end
    end
    post :employee_cvs, constraints: ->(req) { req.params.key?(:save) }, to: 'employee_cvs#create_as_ready'
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
    resource :balance, only: %i[show destroy] do
      resources :withdrawal_methods, except: %i[show new create destroy]
      member do
        get :withdrawal, to: 'balances#withdrawal_methods'
        put :withdrawal, to: 'balances#withdrawal'
        get 'contractor_invoice/:id', to: 'balances#contractor_invoice', as: :contractor_invoice
      end
    end
    put :balance, to: 'balances#deposit'
  end

  get '/orders/:customer_id', to: 'orders#customer_orders', as: :orders_by_customer, constraints: { state: /[_A-Za-z]+/ }
  resources :orders, only: %i[index] do
    member do
      get :download_document
      get :info
      put :add_to_favorites
      put :remove_from_favorites
    end
  end

  resources :crm_columns, only: %i[create update destroy] do
    post :add_employee_cv
    put :update_employee_cv

    collection do
      delete :destroy_employee_cv
    end
  end

  resources :recruiters, only: %i[index show]
  resources :support_messages, only: %i[new create]
  resources :term_of_uses, only: %i[index] do
    post :accept
  end

  resources :terms, only: %i[index] do
    collection do
      post :accept
      %w(freelance industrial).each do |space|
        scope space do
          get :download, to: "terms##{space}_download", as: "#{space}_download_terms"
        end
      end
    end
  end

  get 'terms/customer/download', to: 'terms#download'
  get 'loading_candidates_interview', controller: 'welcome'
  get :calendar_events, controller: 'welcome'
  mount Thredded::Engine => '/forum'
  mount ActionCable.server => '/cable'
  root to: 'welcome#index'
end
