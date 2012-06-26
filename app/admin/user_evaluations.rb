ActiveAdmin.register UserEvaluation do
  
  scope_to :current_user 
  
  filter :bird 
  filter :evaluation_set
  
  menu :label => "Evaluations"

  show :title => :description do |ua|
    attributes_table do
      row :evaluation_set
      row :bird
      table_for(ua.user_evaluation_answers) do 
        column "Evaluation Responses" do |a|
          "#{a.evaluation_question.to_s} #{a.answer}"
        end
      end
    end
  end
  
  index do
    column :bird
    column :evaluation_set
    column :updated_at
    default_actions      
  end
  
  form do
    if EvaluationSet.all.count == 0
      "There are no evaluation question sets yet."
    else
      render :partial => "form"
    end
  end
  
  action_item :only => :show do
    link_to("New User Evaluation", new_admin_user_evaluation_path )
  end
  
  controller do
    def create
      create! do |format|
        format.html {redirect_to edit_admin_user_evaluation_path(@user_evaluation)}
      end
    end
  end 
  
end
