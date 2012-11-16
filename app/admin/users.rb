ActiveAdmin.register User do

  menu :if => proc{current_user.is_admin?}, :priority => 1000
  
  index do
    column :email;
    column :created_at;
    column "Last Login" do |u|
      u.current_sign_in_at.localtime
    end
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
