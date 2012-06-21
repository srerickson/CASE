ActiveAdmin.register EvaluationSet do
 
  show :title => :name

  index do 
    column :name
    column :owner
    column :locked do |es|
      es.locked ? "Yes" : "No"
    end
    default_actions
  end

  show do |es|
    attributes_table do
      row :name
      row :owner
      table_for(es.evaluation_questions) do
          column :question
      end
      
    end
  end


  form do |f|
    f.inputs "General" do 
      f.input :name
      f.input :locked
      f.input :owner_id, :as => :hidden, :value => current_user.id
    end
    f.has_many :evaluation_questions do |q|
      q.input :question, :as => :string 
      q.input :position
    end
    f.buttons
  end
  
end
