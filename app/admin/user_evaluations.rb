ActiveAdmin.register UserEvaluation do
  
  scope_to :current_user 
  
  filter :bird 
  filter :evaluation_set
  
  menu :label => "Your Evaluations", :priority => 15


  show :title => :description do |ua|
    attributes_table do
      row :evaluation_set
      row :bird
      row :comment
      table_for(ua.user_evaluation_answers) do 
        column "Your Evaluation Responses" do |a|
          div(:class => :question) do  
            a.evaluation_question.to_s
          end
          div :class => "answer" do
            unless a.answer.blank?
              span :class => css_class_for_answer(a) do
               a.answer 
              end
              span ": #{a.comment}" unless a.comment.blank?
            end
          end
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

    def comments 
      @evaluation_set = EvaluationSet.find(params[:evaluation_set_id])
      @bird = Bird.find(params[:bird_id])
      @user_evaluations = UserEvaluation.where({
        :evaluation_set_id => @evaluation_set.id,
        :bird_id => @bird.id
      })
      @comments = @user_evaluations.select{|ue| !ue.comment.blank? }.map{|ue| ue.comment }
    end

  end 


  # Fix Action Buttons 
  config.clear_action_items!
  
  action_item :only => :index do
    link_to "New Evaluation", new_admin_user_evaluation_path
  end  
    
  action_item :only => :show do
    link_to "Edit", edit_admin_user_evaluation_path(user_evaluation)
  end  

  action_item :only => :edit do
    link_to "Delete", admin_user_evaluation_path(user_evaluation), :method => :delete, :confirm => "Are you really sure you want to delete this evaluation?"
  end 

end
