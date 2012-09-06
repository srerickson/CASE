ActiveAdmin.register UserEvaluation do
  
  scope_to :current_user 
  
  filter :bird 
  filter :evaluation_set
  
  menu :label => "Your Evaluations", :priority => 15

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
    column :evaluation_set do |ue|
      ue.evaluation_set.name
    end
    column :complete do |ue|
       if ue.unanswered_questions.size == 0 
          image_tag "green-check.png", :height => "10"
       else
          image_tag "red-x-large.png", :height => "10"
       end

    end
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
    def new
      @bird = nil
      unless params[:bird].nil?
        @bird = Bird.find(params[:bird].to_i)
      end
      new!
    end
    def create
      create! do |format|
        format.html {redirect_to edit_admin_user_evaluation_path(@user_evaluation)}
      end
    end
  end 
  
end
