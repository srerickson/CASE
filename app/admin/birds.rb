ActiveAdmin.register Bird do
  
  index do |f|
    column :name
    default_actions
  end
  
  form :partial => "form"
  
end
