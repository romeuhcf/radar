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

ActiveRecord::Schema.define(version: 20151106012352) do

  create_table "bills", force: :cascade do |t|
    t.integer  "customer_id",          limit: 4
    t.string   "customer_type",        limit: 255
    t.date     "reference_date_begin"
    t.date     "reference_date_end"
    t.decimal  "grand_total",                      precision: 10
    t.boolean  "paid"
    t.date     "due_to"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "bills", ["customer_type", "customer_id"], name: "index_bills_on_customer_type_and_customer_id", using: :btree

  create_table "carriers", force: :cascade do |t|
    t.string   "media",                limit: 255
    t.string   "name",                 limit: 255
    t.boolean  "active",                             default: false
    t.string   "implementation_class", limit: 255
    t.text     "configuration",        limit: 65535
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "carriers", ["active", "media"], name: "index_carriers_on_active_and_media", using: :btree

  create_table "configurations", force: :cascade do |t|
    t.string   "key",         limit: 255
    t.string   "description", limit: 255
    t.string   "default",     limit: 255
    t.string   "value",       limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "configurations", ["key"], name: "index_configurations_on_key", using: :btree

  create_table "destinations", force: :cascade do |t|
    t.string   "kind",            limit: 255
    t.string   "address",         limit: 255
    t.integer  "contacted_times", limit: 4
    t.date     "last_used_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "destinations", ["kind", "last_used_at", "contacted_times"], name: "index_destinations_on_kind_and_last_used_at_and_contacted_times", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.integer  "owner_id",   limit: 4
    t.string   "owner_type", limit: 255
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "divisions", ["owner_type", "owner_id"], name: "index_divisions_on_owner_type_and_owner_id", using: :btree

  create_table "message_carrier_infos", force: :cascade do |t|
    t.integer  "carrier_id",     limit: 4
    t.string   "carrier_hash",   limit: 255
    t.string   "carrier_status", limit: 255
    t.integer  "message_id",     limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "message_carrier_infos", ["carrier_hash"], name: "index_message_carrier_infos_on_carrier_hash", using: :btree
  add_index "message_carrier_infos", ["carrier_id"], name: "index_message_carrier_infos_on_carrier_id", using: :btree
  add_index "message_carrier_infos", ["message_id"], name: "index_message_carrier_infos_on_message_id", using: :btree

  create_table "message_contents", force: :cascade do |t|
    t.string   "kind",       limit: 255
    t.integer  "message_id", limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "message_contents", ["message_id"], name: "index_message_contents_on_message_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "transmission_request_id", limit: 4
    t.string   "media",                   limit: 255
    t.string   "transmission_state",      limit: 255
    t.date     "reference_date"
    t.integer  "weight",                  limit: 4,   default: 1
    t.boolean  "paid",                                default: false
    t.datetime "scheduled_to"
    t.datetime "sent_at"
    t.boolean  "billable"
    t.integer  "bill_id",                 limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "destination_id",          limit: 4
  end

  add_index "messages", ["bill_id"], name: "index_messages_on_bill_id", using: :btree
  add_index "messages", ["destination_id"], name: "index_messages_on_destination_id", using: :btree
  add_index "messages", ["media", "paid", "transmission_state", "reference_date"], name: "idx_mesages_report", using: :btree
  add_index "messages", ["transmission_request_id"], name: "index_messages_on_transmission_request_id", using: :btree

  create_table "route_providers", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "provider_klass", limit: 255
    t.string   "options",        limit: 255
    t.boolean  "enabled"
    t.boolean  "priority"
    t.string   "service_type",   limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "route_providers", ["enabled", "service_type", "name"], name: "index_route_providers_on_enabled_and_service_type_and_name", using: :btree

  create_table "transmission_requests", force: :cascade do |t|
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.integer  "user_id",        limit: 4
    t.string   "identification", limit: 255
    t.string   "requested_via",  limit: 255
    t.string   "status",         limit: 255
    t.date     "reference_date"
    t.integer  "messages_count", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "division_id",    limit: 4
  end

  add_index "transmission_requests", ["division_id"], name: "index_transmission_requests_on_division_id", using: :btree
  add_index "transmission_requests", ["owner_type", "owner_id"], name: "index_transmission_requests_on_owner_type_and_owner_id", using: :btree
  add_index "transmission_requests", ["requested_via", "status", "reference_date"], name: "idx_requests_for_admin_report", using: :btree
  add_index "transmission_requests", ["user_id", "requested_via", "status", "reference_date"], name: "idx_requests_for_user_report", using: :btree
  add_index "transmission_requests", ["user_id"], name: "index_transmission_requests_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "message_carrier_infos", "carriers"
  add_foreign_key "message_carrier_infos", "messages"
  add_foreign_key "message_contents", "messages"
  add_foreign_key "messages", "destinations"
  add_foreign_key "transmission_requests", "divisions"
  add_foreign_key "transmission_requests", "users"
end
