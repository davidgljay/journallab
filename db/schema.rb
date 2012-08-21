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

ActiveRecord::Schema.define(:version => 20120818050011) do

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
    t.text     "method_text"
    t.boolean  "is_public"
    t.text     "alt_approach"
    t.integer  "get_paper_id"
  end

  add_index "assertions", ["fig_id"], :name => "index_assertions_on_fig_id"
  add_index "assertions", ["figsection_id"], :name => "index_assertions_on_figsection_id"
  add_index "assertions", ["get_paper_id"], :name => "index_assertions_on_get_paper_id"
  add_index "assertions", ["paper_id"], :name => "index_assertions_on_paper_id"
  add_index "assertions", ["user_id"], :name => "index_assertions_on_user_id"

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
    t.boolean  "is_public"
    t.boolean  "author"
    t.integer  "get_paper_id"
    t.boolean  "anonymous"
  end

  add_index "comments", ["fig_id"], :name => "index_comments_on_fig_id"
  add_index "comments", ["figsection_id"], :name => "index_comments_on_figsection_id"
  add_index "comments", ["get_paper_id"], :name => "index_comments_on_get_paper_id"
  add_index "comments", ["paper_id"], :name => "index_comments_on_paper_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "discussions", :force => true do |t|
    t.string   "name"
    t.integer  "paper_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "starttime"
    t.datetime "endtime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "figs", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_uid"
    t.string   "image_name"
    t.boolean  "nosections"
  end

  add_index "figs", ["paper_id"], :name => "index_figs_on_paper_id"

  create_table "figsections", :force => true do |t|
    t.integer  "fig_id"
    t.integer  "num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "get_paper_id"
  end

  add_index "figsections", ["fig_id"], :name => "index_figsections_on_fig_id"
  add_index "figsections", ["get_paper_id"], :name => "index_figsections_on_get_paper_id"

  create_table "filters", :force => true do |t|
    t.integer  "group_id"
    t.integer  "paper_id"
    t.integer  "comment_id"
    t.integer  "question_id"
    t.integer  "assertion_id"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.boolean  "supplementary"
  end

  add_index "filters", ["assertion_id"], :name => "index_filters_on_assertion_id"
  add_index "filters", ["comment_id"], :name => "index_filters_on_comment_id"
  add_index "filters", ["paper_id"], :name => "index_filters_on_paper_id"
  add_index "filters", ["question_id"], :name => "index_filters_on_question_id"

  create_table "follows", :force => true do |t|
    t.integer  "follow_id"
    t.string   "follow_type"
    t.integer  "user_id"
    t.string   "search_term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "latest_search"
    t.integer  "newcount",      :default => 0
  end

  create_table "groups", :force => true do |t|
    t.text     "name"
    t.text     "desc"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.text     "feed"
    t.text     "most_viewed"
    t.boolean  "public"
    t.integer  "newcount",    :default => 0
  end

  create_table "journals", :force => true do |t|
    t.text     "name"
    t.string   "feedurl"
    t.string   "url"
    t.boolean  "open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "latest_issue"
  end

  create_table "maillogs", :force => true do |t|
    t.string   "purpose"
    t.integer  "user_id"
    t.integer  "about_id"
    t.string   "about_type"
    t.datetime "conversiona"
    t.datetime "conversionb"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "lead"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

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
    t.text     "abstract",           :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_link"
    t.datetime "pubdate"
    t.text     "h_map"
    t.text     "first_last_authors"
    t.text     "description"
    t.string   "doi"
    t.text     "reaction_map"
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
    t.boolean  "is_public"
    t.boolean  "author"
    t.integer  "get_paper_id"
    t.boolean  "anonymous"
  end

  add_index "questions", ["fig_id"], :name => "index_questions_on_fig_id"
  add_index "questions", ["figsection_id"], :name => "index_questions_on_figsection_id"
  add_index "questions", ["get_paper_id"], :name => "index_questions_on_get_paper_id"
  add_index "questions", ["paper_id"], :name => "index_questions_on_paper_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "reactions", :force => true do |t|
    t.string   "name"
    t.integer  "about_id"
    t.string   "about_type"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "get_paper_id"
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

  create_table "shares", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "fig_id"
    t.integer  "figsection_id"
    t.integer  "get_paper_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.text     "text"
    t.integer  "tone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["get_paper_id"], :name => "index_shares_on_get_paper_id"

  create_table "subscriptions", :force => true do |t|
    t.string  "category"
    t.integer "user_id"
    t.boolean "receive_mail"
  end

  create_table "sumreqs", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "fig_id"
    t.integer  "figsection_id"
    t.integer  "get_paper_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "summarized"
  end

  add_index "sumreqs", ["get_paper_id"], :name => "index_sumreqs_on_get_paper_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.boolean  "admin",                :default => false
    t.string   "anon_name"
    t.text     "specialization"
    t.string   "profile_link"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "homepage"
    t.string   "cv"
    t.string   "position"
    t.string   "institution"
    t.boolean  "verified",             :default => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "paper_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.integer  "about_id"
    t.string   "about_type"
    t.string   "visit_type"
  end

  add_index "visits", ["paper_id"], :name => "index_visits_on_paper_id"
  add_index "visits", ["user_id"], :name => "index_visits_on_user_id"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assertion_id"
    t.integer  "comment_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_for_id"
    t.integer  "get_paper_id"
  end

  add_index "votes", ["assertion_id"], :name => "index_votes_on_assertion_id"
  add_index "votes", ["get_paper_id"], :name => "index_votes_on_get_paper_id"

end
