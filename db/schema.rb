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

ActiveRecord::Schema.define(version: 20150422194931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.text     "synopsis"
    t.text     "authers"
    t.integer  "duration"
    t.text     "target_audience"
    t.text     "author_bio"
    t.integer  "book_type",       default: 0
    t.string   "image"
    t.string   "crop_x"
    t.string   "crop_y"
    t.string   "crop_w"
    t.string   "crop_h"
    t.string   "temp_image"
    t.boolean  "on_front_page",   default: false
    t.boolean  "is_free",         default: false
  end

  create_table "books_categories", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_chapter_id"
    t.boolean  "favorite",           default: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "row_order",  default: 0
  end

  create_table "chapters", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "content"
    t.integer  "book_id"
  end

  add_index "chapters", ["book_id"], name: "index_chapters_on_book_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "highlights", force: :cascade do |t|
    t.integer  "chapter_id"
    t.integer  "books_user_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",            null: false
    t.string   "encrypted_password",     default: "",            null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "unconfirmed"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "first_name"
    t.string   "last_name",              default: ""
    t.string   "provider"
    t.string   "uid"
    t.string   "location"
    t.string   "picture"
    t.date     "birthday"
    t.string   "language"
    t.boolean  "has_password",           default: true
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "newsletter",             default: false
    t.integer  "tariff_type",            default: 0
    t.date     "expire_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
