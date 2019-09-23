# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_23_114253) do

  create_table "account_statements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "src_account"
    t.date "date"
    t.string "sender"
    t.string "number"
    t.decimal "amount", precision: 10, scale: 2
    t.json "data"
    t.bigint "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.index ["account_id"], name: "index_account_statements_on_account_id"
    t.index ["number", "date", "src_account"], name: "index_account_statements_on_number_and_date_and_src_account", unique: true
  end

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "account_number"
    t.string "corr_account"
    t.string "bic"
    t.text "bank"
    t.text "bank_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "accountable_type"
    t.bigint "accountable_id"
    t.string "inn"
    t.string "kpp"
    t.boolean "active"
    t.index ["accountable_type", "accountable_id"], name: "index_accounts_on_accountable_type_and_accountable_id"
  end

  create_table "balances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_balances_on_profile_id"
  end

  create_table "bill_transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.text "description"
    t.string "transaction_type"
    t.bigint "balance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_id"], name: "index_bill_transactions_on_balance_id"
  end

  create_table "bot_callbacks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "candidate_id"
    t.string "guid"
    t.json "call_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_cities_on_title"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "text"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_comments_on_order_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "address"
    t.string "mail_address"
    t.string "phone"
    t.string "fax"
    t.string "email"
    t.string "inn"
    t.string "kpp"
    t.string "ogrn"
    t.string "director"
    t.string "acts_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "own_company", default: false
    t.bigint "profile_id"
    t.boolean "active", default: false
    t.string "companyable_type"
    t.bigint "companyable_id"
    t.string "legal_form"
    t.string "label"
    t.index ["companyable_type", "companyable_id"], name: "index_companies_on_companyable_type_and_companyable_id"
    t.index ["profile_id"], name: "index_companies_on_profile_id"
  end

  create_table "complaints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "state"
    t.text "text"
    t.bigint "proposal_employee_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_complaints_on_profile_id"
    t.index ["proposal_employee_id"], name: "index_complaints_on_proposal_employee_id"
  end

  create_table "employee_cvs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.date "birthdate"
    t.bigint "proposal_id"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.string "state"
    t.json "ext_data"
    t.integer "profile_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "phone_number"
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.string "phone_number_alt"
    t.json "passport"
    t.text "education"
    t.text "remark"
    t.text "experience"
    t.integer "super_job_id"
    t.string "email"
    t.index ["proposal_id"], name: "index_employee_cvs_on_proposal_id"
  end

  create_table "holidays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "state"
    t.bigint "order_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_invites_on_order_id"
    t.index ["profile_id"], name: "index_invites_on_profile_id"
  end

  create_table "invoice_number_seqs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "invoice_number"
  end

  create_table "invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "invoice_number"
    t.decimal "amount", precision: 10, scale: 2
    t.json "seller"
    t.json "buyer"
    t.json "goods"
    t.string "state"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_invoices_on_profile_id"
  end

  create_table "message_to_supports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sender_name"
    t.string "email_address"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "text"
    t.boolean "income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sender_id"
    t.bigint "ticket_id"
    t.string "sender_name"
    t.index ["ticket_id"], name: "index_messages_on_ticket_id"
  end

  create_table "oauths", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "type"
    t.string "code"
    t.string "access_token"
    t.string "refresh_token"
    t.integer "ttl"
    t.integer "expires_in"
    t.string "token_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "query_params"
    t.bigint "contractor_id"
  end

  create_table "order_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_profiles_on_order_id"
    t.index ["profile_id"], name: "index_order_profiles_on_profile_id"
  end

  create_table "order_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "specialization"
    t.string "city"
    t.integer "salary_from"
    t.integer "salary_to"
    t.text "description"
    t.integer "warranty_period"
    t.string "state"
    t.bigint "profile_id"
    t.integer "number_of_employees"
    t.decimal "customer_price", precision: 10, scale: 2
    t.decimal "contractor_price", precision: 10, scale: 2
    t.integer "position_id"
    t.decimal "customer_total", precision: 10, scale: 2
    t.decimal "contractor_total", precision: 10, scale: 2
    t.json "other_info"
    t.string "skill"
    t.string "experience"
    t.string "district"
    t.text "schedule"
    t.string "work_period"
    t.string "urgency"
    t.integer "base_customer_price"
    t.integer "base_contractor_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "place_of_work"
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.json "contact_person"
    t.text "salary"
    t.string "urgency_level"
    t.boolean "for_cis"
    t.boolean "advertising"
    t.text "adv_text"
    t.bigint "production_site_id"
    t.index ["production_site_id"], name: "index_order_templates_on_production_site_id"
    t.index ["profile_id"], name: "index_order_templates_on_profile_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "specialization"
    t.string "city"
    t.integer "salary_from"
    t.integer "salary_to"
    t.text "description"
    t.integer "commission"
    t.integer "payment_type", default: 0
    t.integer "warranty_period", default: 10
    t.integer "number_of_recruiters", default: 1
    t.boolean "enterpreneurs_only"
    t.boolean "accepted"
    t.string "visibility"
    t.string "state"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_employees", default: 1
    t.decimal "customer_price", precision: 10, scale: 2
    t.decimal "contractor_price", precision: 10, scale: 2
    t.integer "total"
    t.integer "position_id"
    t.decimal "customer_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "contractor_total", precision: 10, scale: 2, default: "0.0"
    t.json "other_info"
    t.string "skill"
    t.string "experience"
    t.string "district"
    t.text "schedule"
    t.string "work_period"
    t.string "urgency"
    t.integer "base_customer_price"
    t.integer "base_contractor_price"
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.text "place_of_work"
    t.json "contact_person"
    t.text "salary"
    t.string "urgency_level"
    t.boolean "for_cis"
    t.boolean "advertising"
    t.text "adv_text"
    t.bigint "production_site_id"
    t.index ["production_site_id"], name: "index_orders_on_production_site_id"
    t.index ["profile_id"], name: "index_orders_on_profile_id"
  end

  create_table "payment_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.json "data"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_payment_orders_on_company_id"
  end

  create_table "positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "duties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "price_group_id"
    t.index ["price_group_id"], name: "index_positions_on_price_group_id"
    t.index ["title"], name: "index_positions_on_title"
  end

  create_table "price_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "customer_price", precision: 10, scale: 2
    t.decimal "contractor_price", precision: 10, scale: 2
  end

  create_table "production_sites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "title"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.string "city"
    t.text "info"
    t.text "phones"
    t.index ["profile_id"], name: "index_production_sites_on_profile_id"
  end

  create_table "profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "phone"
    t.string "email"
    t.string "contact_person"
    t.string "company_name"
    t.string "profile_type"
    t.text "description"
    t.string "city"
    t.string "rating"
    t.timestamp "last_seen"
    t.string "state"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legal_form"
    t.boolean "manager"
  end

  create_table "proposal_employees", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "proposal_id"
    t.bigint "order_id"
    t.bigint "profile_id"
    t.bigint "employee_cv_id"
    t.date "date_hired"
    t.string "state"
    t.json "marks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "hiring_date"
    t.date "firing_date"
    t.date "warranty_date"
    t.text "hd_correction_reason"
    t.date "arrival_date"
    t.boolean "hiring_date_corrected"
    t.timestamp "interview_date"
    t.bigint "dst_order_id"
    t.index ["employee_cv_id"], name: "index_proposal_employees_on_employee_cv_id"
    t.index ["order_id"], name: "index_proposal_employees_on_order_id"
    t.index ["profile_id"], name: "index_proposal_employees_on_profile_id"
    t.index ["proposal_id"], name: "index_proposal_employees_on_proposal_id"
  end

  create_table "proposals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "description"
    t.string "state"
    t.bigint "order_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted"
    t.index ["order_id"], name: "index_proposals_on_order_id"
    t.index ["profile_id"], name: "index_proposals_on_profile_id"
  end

  create_table "royce_connector", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "roleable_type", null: false
    t.bigint "roleable_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_royce_connector_on_role_id"
    t.index ["roleable_type", "roleable_id"], name: "index_royce_connector_on_roleable_type_and_roleable_id"
  end

  create_table "royce_role", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_royce_role_on_name"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "specializations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_specializations_on_title"
  end

  create_table "staffers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password_digest"
    t.string "guid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "super_job_configs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "code"
    t.string "access_token"
    t.string "refresh_token"
    t.integer "ttl"
    t.integer "expires_in"
    t.string "token_type"
    t.bigint "contractor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "references"
  end

  create_table "super_job_queries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "title"
    t.json "query_params"
    t.boolean "active"
    t.bigint "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_id"], name: "index_super_job_queries_on_config_id"
  end

  create_table "tax_calculations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "tax_base", precision: 10, scale: 2
    t.decimal "tax_amount", precision: 10, scale: 2
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_tax_calculations_on_profile_id"
  end

  create_table "tax_offices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "payment_name"
    t.string "inn"
    t.string "kpp"
    t.string "oktmo"
    t.string "bank_name"
    t.string "bank_bic"
    t.string "bank_account"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_tax_offices_on_company_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type"
    t.string "state"
    t.bigint "proposal_employee_id"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reason"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "towns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.integer "id_region"
    t.integer "id_country"
    t.string "title"
    t.string "title_eng"
    t.integer "super_job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_action_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "receiver_id"
    t.integer "subject_id"
    t.string "subject_type"
    t.string "subject_role"
    t.text "action"
    t.integer "object_id"
    t.string "object_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "receiver_ids"
    t.string "login"
    t.integer "order_id"
    t.integer "employee_cv_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "full_name"
    t.string "photo_url"
    t.bigint "profile_id"
    t.string "password_digest"
    t.string "guid"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "is_active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "withdrawal_methods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "type"
    t.bigint "profile_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_withdrawal_methods_on_profile_id"
  end

  add_foreign_key "account_statements", "accounts"
  add_foreign_key "balances", "profiles"
  add_foreign_key "bill_transactions", "balances"
  add_foreign_key "comments", "orders"
  add_foreign_key "companies", "profiles"
  add_foreign_key "complaints", "profiles"
  add_foreign_key "complaints", "proposal_employees"
  add_foreign_key "employee_cvs", "proposals"
  add_foreign_key "invites", "orders"
  add_foreign_key "invites", "profiles"
  add_foreign_key "invoices", "profiles"
  add_foreign_key "order_profiles", "orders"
  add_foreign_key "order_profiles", "profiles"
  add_foreign_key "order_templates", "production_sites"
  add_foreign_key "order_templates", "profiles"
  add_foreign_key "orders", "production_sites"
  add_foreign_key "orders", "profiles"
  add_foreign_key "payment_orders", "companies"
  add_foreign_key "positions", "price_groups"
  add_foreign_key "production_sites", "profiles"
  add_foreign_key "proposals", "orders"
  add_foreign_key "proposals", "profiles"
  add_foreign_key "super_job_queries", "super_job_configs", column: "config_id"
  add_foreign_key "tax_calculations", "profiles"
  add_foreign_key "tax_offices", "companies"
  add_foreign_key "tickets", "users"
  add_foreign_key "users", "profiles"
  add_foreign_key "withdrawal_methods", "profiles"
end
