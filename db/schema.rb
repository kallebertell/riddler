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

ActiveRecord::Schema.define(:version => 20101109194039) do

  create_table "answers", :force => true do |t|
    t.integer  "choice_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", :force => true do |t|
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pic_url"
    t.string   "text"
    t.boolean  "correct"
    t.string   "key"
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "round_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "game_id"
    t.integer  "correct_choice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.string   "type"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.integer  "facebook_id"
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.string   "timezone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "birthday"
    t.string   "link"
    t.string   "locale"
    t.boolean  "verified"
    t.datetime "updated_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "answers", "choices", :name => "answers_choice_id_fk"
  add_foreign_key "answers", "users", :name => "answers_user_id_fk"

  add_foreign_key "choices", "questions", :name => "choices_question_id_fk"

  add_foreign_key "questions", "choices", :name => "questions_correct_choice_id_fk", :column => "correct_choice_id"
  add_foreign_key "questions", "games", :name => "questions_game_id_fk"

end
