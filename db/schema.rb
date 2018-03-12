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

ActiveRecord::Schema.define(version: 20180309202935) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_services", force: :cascade do |t|
    t.integer "user_id"
    t.string  "service_description"
    t.integer "service_type",        default: 1
    t.integer "custom_service",      default: 0
  end

  create_table "business_types", force: :cascade do |t|
    t.string "industry_code"
    t.string "description"
  end

  create_table "proposal_details", force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "service_id"
    t.integer "tier1_applicable"
    t.integer "tier2_applicable"
    t.integer "tier3_applicable"
  end

  create_table "proposal_settings", force: :cascade do |t|
    t.integer "user_id"
    t.string  "return_email"
    t.string  "tier1_name"
    t.string  "tier2_name"
    t.string  "tier3_name"
    t.string  "proposal_default_text"
  end

  add_index "proposal_settings", ["user_id"], name: "proposal_settings_index", unique: true, using: :btree

  create_table "proposal_template_details", force: :cascade do |t|
    t.integer "proposal_template_id"
    t.integer "service_id"
    t.integer "tier1_applicable",     default: 0
    t.integer "tier2_applicable",     default: 0
    t.integer "tier3_applicable",     default: 0
  end

  create_table "proposal_templates", force: :cascade do |t|
    t.integer "user_id"
    t.integer "service_type",         default: 1
    t.string  "template_description"
  end

  create_table "proposals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "service_type",                            default: 1
    t.string   "business_name"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "contact_first"
    t.string   "contact_last"
    t.string   "contact_email"
    t.integer  "business_type"
    t.decimal  "fee_tier1",       precision: 8, scale: 2, default: 0.0
    t.decimal  "fee_tier2",       precision: 8, scale: 2, default: 0.0
    t.decimal  "fee_tier3",       precision: 8, scale: 2, default: 0.0
    t.decimal  "actual_fee",      precision: 8, scale: 2, default: 0.0
    t.text     "proposal_text"
    t.integer  "proposal_status"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "business_name",          default: "", null: false
    t.string   "owner_first",            default: "", null: false
    t.string   "owner_last",             default: "", null: false
    t.string   "address",                default: "", null: false
    t.string   "address2",               default: ""
    t.string   "city",                   default: "", null: false
    t.string   "state",                  default: "", null: false
    t.string   "phone",                  default: "", null: false
    t.string   "website",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "zip_code",               default: "", null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
