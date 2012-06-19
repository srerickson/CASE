class Asset < ActiveRecord::Base
  belongs_to :attached_to, :polymorphic => true
  has_attached_file :asset, 
    :styles => { :sq600 => "600x600", :sq300 => "300x300>", :sq100 => "100x100>", :sq50 => "50x50>" },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"    

  def original_url
    asset.url(:original)
  end

end
