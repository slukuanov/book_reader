class CreateUser < ActiveRecord::Migration
  def change
    create_table "users", force: true do |t|
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
    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end
end
