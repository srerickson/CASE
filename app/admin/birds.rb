ActiveAdmin.register Bird do

  menu :priority => 1
  
  index do |f|
    column :name
    default_actions
  end
  
  form :partial => "form"
  
end
