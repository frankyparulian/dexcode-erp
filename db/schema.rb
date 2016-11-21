# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160729085327) do

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "email",           null: false
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.text     "billing_address"
    t.string   "code"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "documents", force: true do |t|
    t.string   "document",          null: false
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type", using: :btree

  create_table "employee_absences", force: true do |t|
    t.date     "date"
    t.string   "reason"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_sick_days"
  end

  create_table "employee_positions", force: true do |t|
    t.string "position"
  end

  create_table "employee_projects", force: true do |t|
    t.integer  "employee_id", null: false
    t.integer  "project_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "position"
    t.integer  "salary",                        default: 0,     null: false
    t.string   "salary_currency",               default: "IDR", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "ktp"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "bank_name"
    t.string   "bank_account_number"
    t.string   "photo"
    t.string   "bank_account_holder"
    t.integer  "parent"
    t.string   "no_npwp"
    t.integer  "status"
    t.integer  "child"
    t.integer  "gender"
    t.date     "date_of_birth"
    t.string   "bank_code"
    t.integer  "review_month",        limit: 1
  end

  add_index "employees", ["parent"], name: "index_employees_on_parent", using: :btree

  create_table "expenses", force: true do |t|
    t.string   "name"
    t.integer  "total",      default: 0, null: false
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "gid"
    t.integer  "client_id"
    t.string   "client_name"
    t.string   "content"
    t.float    "rating"
    t.boolean  "allow_publish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "google_apis", force: true do |t|
    t.text     "client_id"
    t.text     "client_secret"
    t.string   "redirect_uri"
    t.text     "access_token"
    t.integer  "expire_in"
    t.text     "id_token"
    t.text     "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: true do |t|
    t.date     "date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.boolean  "is_joint_holiday"
  end

  create_table "interviews", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",      default: "scheduled"
    t.integer  "company_id"
  end

  create_table "invites", force: true do |t|
    t.integer  "employee_id"
    t.string   "email"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_items", force: true do |t|
    t.integer  "invoice_id"
    t.string   "name"
    t.float    "quantity"
    t.float    "unit_price"
    t.float    "amount"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "client_id"
    t.integer  "company_id"
    t.float    "subtotal"
    t.float    "tax_percent"
    t.float    "tax_amount"
    t.float    "total"
    t.date     "begin_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "number"
    t.text     "payment_information"
  end

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "projects", force: true do |t|
    t.integer  "client_id",  null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salary_histories", force: true do |t|
    t.integer  "employee_id"
    t.float    "salary",          default: 0.0,   null: false
    t.string   "salary_currency", default: "IDR", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "salary_histories", ["employee_id"], name: "index_salary_histories_on_employee_id", using: :btree

  create_table "time_entries", force: true do |t|
    t.integer  "employee_id", null: false
    t.integer  "project_id",  null: false
    t.float    "hours",       null: false
    t.date     "date",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",               null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "business_owner", null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
