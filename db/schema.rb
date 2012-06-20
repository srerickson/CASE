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

ActiveRecord::Schema.define(:version => 20120618211047) do

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
    t.text     "name",                   :null => false
    t.text     "url",                    :null => false
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

end
