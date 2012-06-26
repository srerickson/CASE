class Bird < ActiveRecord::Base

  has_paper_trail
  
  #default_scope :order => "birds.name ASC"

  belongs_to :genus_type
  belongs_to :habitat
  belongs_to :fse_org_style, :class_name => "OrgStyle", :foreign_key => "fse_org_style_id"
  belongs_to :op_org_style, :class_name => "OrgStyle", :foreign_key => "op_org_style_id"

  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"

  has_many :user_evaluations

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

  validates_presence_of :name

  accepts_nested_attributes_for :logo, :allow_destroy => true
  accepts_nested_attributes_for :images, :allow_destroy => true

  attr_accessor :uploaded_logo #upload to this attr for replacing logos
  def uploaded_logo=(img)
    logo.destroy unless logo.nil?
    f = Asset.new(:asset => img, :attached_to => self, :role => "logo")
    f.save
  end
 
  scope :recently_updated, lambda { |n| order("updated_at DESC").limit(n) }
 
 
end
