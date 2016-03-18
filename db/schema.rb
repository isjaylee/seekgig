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

ActiveRecord::Schema.define(version: 20160317102436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.decimal  "amount",                      null: false
    t.text     "description",                 null: false
    t.boolean  "archived",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gig_id"
    t.integer  "user_id"
  end

  add_index "bids", ["gig_id"], name: "index_bids_on_gig_id", using: :btree
  add_index "bids", ["user_id"], name: "index_bids_on_user_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "updated_at"
    t.boolean  "archived",     default: false
    t.datetime "created_at"
  end

  create_table "gigs", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description",                 null: false
    t.decimal  "budget",                      null: false
    t.integer  "status",      default: 0,     null: false
    t.integer  "awarded_bid"
    t.string   "location",                    null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "uid",                         null: false
    t.boolean  "archived",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "user_id"
  end

  add_index "gigs", ["category_id"], name: "index_gigs_on_category_id", using: :btree
  add_index "gigs", ["uid"], name: "index_gigs_on_uid", unique: true, using: :btree
  add_index "gigs", ["user_id"], name: "index_gigs_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.text     "subject"
    t.text     "body",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "conversation_id"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.text     "comment",    null: false
    t.integer  "rating",     null: false
    t.integer  "reviewer",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "gig_id"
  end

  add_index "reviews", ["gig_id"], name: "index_reviews_on_gig_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "username",                               null: false
    t.integer  "uid"
    t.text     "description",                            null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "location",                               null: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "archived",               default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "searchable",             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
