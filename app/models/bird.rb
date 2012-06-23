class Bird < ActiveRecord::Base

  default_scope :order => "name ASC"

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
 
  scope :evaluated_with_evaluation_set, lambda { |es|
    includes(:user_evaluations).where("user_evaluations.evaluation_set_id = ?", es)
  }
  
  
  
#  def as_json(options={})
#     super(options.merge(
#      :include => {
#        :logo => {:methods => [:original_url]},
#        :images => {:methods => [:original_url]},
#        :habitat => {},
#        :genus_type => {},
#        :fse_org_style => {},
#        :op_org_style => {}
#      }
#    ))
#  end


end
