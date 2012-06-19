class Bird < ActiveRecord::Base
  belongs_to :genus_type
  belongs_to :habitat
  belongs_to :fse_org_style, :class_name => "OrgStyle", :foreign_key => "fse_org_style_id"
  belongs_to :op_org_style, :class_name => "OrgStyle", :foreign_key => "op_org_style_id"

  belongs_to :updated_by, :class_name => "AdminUser", :foreign_key => "updated_by_id"

  has_one :logo, 
    :class_name => "Asset", 
    :as => "attached_to", 
    :conditions => {:role => "logo"},
    :dependent => :destroy    

  has_many :images,
    :class_name => "Asset",
    :as => "attached_to",
    :conditions => {:role => nil},
    :dependent => :destroy

  accepts_nested_attributes_for :logo, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true


  attr_accessor :uploaded_logo #upload to this attr for replacing logos
  def uploaded_logo=(img)
    logo.destroy unless logo.nil?
    f = Asset.new(:asset => img, :attached_to => self, :role => "logo")
    f.save
  end
  


  validates_presence_of :name

#  define_index do 
#    indexes :name, :sortable => true
#    indexes habitat(:name), :as => :habitat, :sortable => true
#    indexes genus_type(:name), :as => :genus_type, :sortable => true
#    indexes foritself
#    indexes brand
#    indexes fse_name
#    indexes fse_org_style(:name), :as => :fse_org_style, :sortable => true
#    indexes fse_owner_founder
#    indexes fse_significant_member
#    indexes fse_mission_statement
#    indexes op_name
#    indexes op_org_style(:name), :as => :op_org_style, :sortable => true
#    indexes op_vip_founders
#    indexes op_typical_member
#    indexes formation
#    indexes history
#    indexes lifespan
#    indexes resource
#    indexes availability
#    indexes participation
#    indexes tasks
#    indexes modularity
#    indexes granularity
#    indexes metrics
#    indexes alliances
#    indexes clients 
#    indexes sponsors
#    indexes elites
#    
#    has habitat_id, :facet => true
#    has genus_type_id, :facet => true
#    has fse_org_style_id, :facet => true
#    has op_org_style_id, :facet => true
#    has created_at
#    has updated_at
#  end  


  def as_json(options={})
     super(options.merge(
      :include => {
        :logo => {:methods => [:original_url]},
        :images => {:methods => [:original_url]},
        :habitat => {},
        :genus_type => {},
        :fse_org_style => {},
        :op_org_style => {}
      }
    ))
  end

  def path
    return "/birds/#{id}"
  end

end
