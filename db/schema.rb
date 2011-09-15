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

ActiveRecord::Schema.define(:version => 20110905102246) do

  create_table "assertions", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "paper_id"
    t.integer  "fig_id"
    t.integer  "figsection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "heatmap"
    t.string   "about"
    t.text     "method"
  end

  create_table "authors", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "initial"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["author_id"], :name => "index_authorships_on_author_id"
  add_index "authorships", ["paper_id", "author_id"], :name => "index_authorships_on_paper_id_and_author_id", :unique => true
  add_index "authorships", ["paper_id"], :name => "index_authorships_on_paper_id"

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "paper_id"
    t.integer  "fig_id"
    t.integer  "figsection_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assertion_id"
    t.string   "form"
    t.integer  "question_id"
  end

  create_table "figs", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "figsections", :force => true do |t|
    t.integer  "fig_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["user_id"], :name => "index_microposts_on_user_id"

  create_table "papers", :force => true do |t|
    t.text     "title"
    t.integer  "pubmed_id"
    t.text     "journal"
    t.text     "abstract",   :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.text     "text"
    t.integer  "paper_id"
    t.integer  "fig_id"
    t.integer  "figsection_id"
    t.integer  "user_id"
    t.integer  "assertion_id"
    t.integer  "question_id"
    t.integer  "votes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "lastname"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "paper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assertion_id"
    t.integer  "comment_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
