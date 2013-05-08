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

ActiveRecord::Schema.define(:version => 20121018161553) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "assets", :force => true do |t|
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "attached_to_id"
    t.string   "attached_to_type"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birds", :force => true do |t|
    t.text     "name",                    :null => false
    t.text     "url",                     :null => false
    t.integer  "genus_type_id"
    t.text     "foritself"
    t.integer  "habitat_id"
    t.text     "brand"
    t.text     "fse_name"
    t.integer  "fse_org_style_id"
    t.text     "fse_owner_founder"
    t.text     "fse_significant_member"
    t.text     "fse_mission_statement"
    t.text     "op_name"
    t.integer  "op_org_style_id"
    t.text     "op_vip_founders"
    t.text     "op_typical_member"
    t.text     "formation"
    t.text     "history"
    t.text     "lifespan"
    t.text     "resource"
    t.text     "availability"
    t.text     "participation"
    t.text     "tasks"
    t.text     "modularity"
    t.text     "granularity"
    t.text     "metrics"
    t.text     "alliances"
    t.text     "clients"
    t.text     "sponsors"
    t.text     "elites"
    t.integer  "comments_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updated_by_id"
    t.text     "summary"
    t.text     "birder_credits"
    t.string   "tangible_problem"
    t.text     "tangible_problem_detail"
  end

  create_table "evaluation_questions", :force => true do |t|
    t.integer  "evaluation_set_id",                    :null => false
    t.integer  "position"
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sub_question",      :default => false
  end

  create_table "evaluation_results", :force => true do |t|
    t.integer "bird_id",                                 :null => false
    t.integer "evaluation_question_id",                  :null => false
    t.integer "yes_count",              :default => 0
    t.integer "no_count",               :default => 0
    t.integer "na_count",               :default => 0
    t.integer "blank_count",            :default => 0
    t.integer "yes_comments",           :default => 0
    t.integer "no_comments",            :default => 0
    t.integer "na_comments",            :default => 0
    t.float   "answer_score",           :default => 0.0
  end

  create_table "evaluation_sets", :force => true do |t|
    t.string   "name"
    t.boolean  "locked"
    t.integer  "owner_id"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible_results", :default => false
  end

  create_table "genus_types", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "habitats", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "org_styles", :force => true do |t|
    t.text     "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_evaluation_answers", :force => true do |t|
    t.integer  "user_evaluation_id",     :null => false
    t.integer  "evaluation_question_id", :null => false
    t.text     "answer"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_evaluations", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "evaluation_set_id", :null => false
    t.integer  "bird_id",           :null => false
    t.boolean  "complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
