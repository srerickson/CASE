ActiveAdmin.register EvaluationSet do
 
  menu :parent => "Evaluations", :label => "Eval Question Sets"
  show :title => :name

  index do 
    column :name
    column :owner
    column :locked do |es|
      es.locked ? "Yes" : "No"
    end
    column "# user evaluations" do |es|
      es.user_evaluations.count   
    end    
    column "# questions" do |es|
      es.evaluation_questions.count   
    end    
    default_actions
  end

  show :title => :name do |es|
    attributes_table do
      row :name
      row :owner
      row :instructions
      table_for(es.evaluation_questions) do
          column :question do |q|
            q.to_s
          end
      end
    end
    panel "Results" do
      table_for(es.all_results) do
        
      end
    end
  end


  form do |f|
    f.inputs "General" do 
      f.input :name
      f.input :instructions
      f.input :locked, :hint => "Use this to prevent modifications that may corrupt responses"
      f.input :owner_id, :as => :hidden, :value => current_user.id
    end
    f.has_many :evaluation_questions do |q|
      q.input :position, :wrapper_html => {:class => "position"}
      q.input :question, :as => :string, :wrapper_html => {:class => "question"}
    end
    f.buttons
  end
  
end
