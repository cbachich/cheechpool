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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131014142122) do

  create_table "challenges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "picksheet_id"
    t.boolean  "player"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "current_week",         :default => 0
    t.datetime "picksheet_close_date"
    t.integer  "finale_week"
  end

  add_index "leagues", ["name"], :name => "index_leagues_on_name", :unique => true

  create_table "leagues_users", :force => true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "admin",      :default => false
    t.integer  "player_id"
  end

  add_index "leagues_users", ["league_id", "user_id"], :name => "index_leagues_users_on_league_id_and_user_id"

  create_table "picksheets", :force => true do |t|
    t.integer  "league_id"
    t.integer  "week"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "player_picks", :force => true do |t|
    t.integer  "player_id"
    t.integer  "value"
    t.boolean  "picked"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.integer  "league_id"
    t.integer  "week"
  end

  create_table "player_wins", :force => true do |t|
    t.integer  "player_id"
    t.integer  "week"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "challenge_id"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "voted_out_week"
    t.string   "image_url"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "team_id"
    t.integer  "league_id"
    t.string   "info_url"
    t.boolean  "redemption",     :default => false
  end

  create_table "scores", :force => true do |t|
    t.integer  "league_id"
    t.integer  "user_id"
    t.integer  "value"
    t.integer  "week"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "smacks", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "league_id"
  end

  add_index "smacks", ["user_id", "created_at"], :name => "index_smacks_on_user_id_and_created_at"

  create_table "team_picks", :force => true do |t|
    t.boolean  "picked"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "team_id"
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.integer  "league_id"
    t.integer  "week"
  end

  create_table "team_wins", :force => true do |t|
    t.integer  "team_id"
    t.integer  "week"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "challenge_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "start_week",   :default => 1
    t.integer  "disband_week"
    t.string   "image_url"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "league_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",            :default => false
    t.integer  "active_league_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
