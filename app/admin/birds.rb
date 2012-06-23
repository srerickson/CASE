ActiveAdmin.register Bird, {:order => :name} do

  show :title => :name 
  menu :priority => 1
  
  form :partial => "form"
    
  index do |f|
    column :logo do |b|
      b.logo.nil? ? "" : image_tag(b.logo.asset.url(:sq50), :height =>"25px");
    end
    column :name
    column :habitat
    column :genus_type
    default_actions
  end
  
  controller do
    def index
      index!
    end
  end   
  
  
end
