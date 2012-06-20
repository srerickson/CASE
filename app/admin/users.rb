ActiveAdmin.register User do

  menu :priority => 10

  index do
    column :email;
    column :created_at;
    column :last_sign_in_at;
    column :sign_in_count;
  end

  form do |f|
    f.inputs "User Credintials" do
     f.input :email;
     f.input :password;
     f.input :password_confirmation;
    end
    f.buttons
  end 
  
end
