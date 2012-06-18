class CreatBirdsTables < ActiveRecord::Migration
  def self.up
  
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

  def self.down
    drop_table "org_styles"
    drop_table "habitats"
    drop_table "genus_types"
    drop_table "birds"
    drop_table "assets"
  end
end
