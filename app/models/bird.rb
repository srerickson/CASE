class Bird < ActiveRecord::Base

  has_paper_trail
  
  #default_scope includes(:logo).order("birds.name ASC")

  belongs_to :genus_type
  belongs_to :habitat
  belongs_to :fse_org_style, :class_name => "OrgStyle", :foreign_key => "fse_org_style_id"
  belongs_to :op_org_style, :class_name => "OrgStyle", :foreign_key => "op_org_style_id"

  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id"

  has_many :user_evaluations, :dependent => :destroy
  has_many :evaluation_results, :inverse_of => :bird

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
 

  def thumbnail_100_url
    begin
      logo.asset.url(:sq100, false)
    rescue
      nil
    end
  end

  def thumbnail_50_url
    begin
      logo.asset.url(:sq50, false)
    rescue
      nil
    end
  end


  # def as_json(options = {})
  #   super({
  #     :methods => [:thumbnail_100_url, :thumbnail_50_url],
  #     :only => [:id,:name]
  #   })
  # end



end
