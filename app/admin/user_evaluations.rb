ActiveAdmin.register UserEvaluation do
  
  menu :label => "Your Evaluations"
  form :partial => "form"
  
  
  controller do
    def create
      create! do |format|
        format.html {redirect_to edit_admin_user_evaluation_path(@user_evaluation)}
      end
    end
  end 
end
