ActiveAdmin.register EvaluationSet do
 
  menu :label => "Evaluations Admin"
  menu :if => proc{current_user.is_admin?}, :parent => "Admin Actions", :priority => 100

  config.clear_sidebar_sections!

  #
  # Views 
  #

  index do 
    column :name do |es|
      link_to es.name, admin_evaluation_set_path(es) 
    end
    column :owner
    column :locked do |es|
      es.locked ? "Yes" : "No"
    end   
    column "Results Visible?" do |es|
      es.visible_results ? "visible" : "hidden"
    end

    column "# questions" do |es|
      es.evaluation_questions.count   
    end
    column "# user evaluations" do |es|
      es.user_evaluations.count   
    end
    column "# birds evaluated" do |es|
      es.birds.count.to_s +
      " / " +
      Bird.all.count.to_s
    end      
    column "" do |es|
      div link_to("Results", results_admin_evaluation_set_path(es), :class=>"member_link")
      div link_to("Result Groups", result_groups_admin_evaluation_set_path(es), :class=>"member_link")      

    end
  end



  show :title => :name do |es|
    attributes_table do
      row :name
      row :owner
      row "Results are public?" do 
        es.visible_results ? image_tag("green-check.png", :height=>"12px") : image_tag("red-x.png", :height=>"12px")
      end
      row :locked do 
        if es.locked
          raw "This evaluations set is <b style='color:red'>locked</b>: it cannot be modified or deleted without first unlocking it." 
        else
          raw "This evaluations set is <b style='color:green'>unlocked</b>: It can be modified or deleted." 
        end
      end
      row :instructions
      table_for(es.evaluation_questions) do
          column :questions do |q|
            q.to_s
          end
      end
    end
    panel "Results Summary" do
      attributes_table_for es do 
        row "# Evaluations" do
          es.user_evaluations.size
        end
        row "# birds evaluated" do
          "#{es.birds.size.to_s} out of #{Bird.all.size}"
        end
      end
    end
  end


  form do |f|
    f.inputs "General" do 
      f.input :name
      f.input :instructions
      f.input :visible_results, :label => "Results are public?"
      f.input :owner_id, :as => :hidden, :value => current_user.id
    end
    f.has_many :evaluation_questions do |q|
      q.input :position, :wrapper_html => {:class => "position"}
      q.input :question, :as => :string, :wrapper_html => {:class => "question"}
      if !q.object.new_record?
        q.input :_destroy, :as => :boolean, :label => "Delete?", :wrapper_html => {:class => "delete"}
      end
      q.form_buffers.last
    end
    f.buttons
  end

  #
  # Controller
  #

  member_action :results, :method => :get do 
    @evaluation_set = EvaluationSet.find(params[:id])
    @results = @evaluation_set.results_by_bird
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end
    respond_with(@results)
  end

  member_action :result_groups, :method => :get do 
    @evaluation_set = EvaluationSet.find(params[:id])
    @result_groups =  @evaluation_set.response_groups    
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end
  end

  member_action :question_analysis, :method => :get do 
    @evaluation_set = EvaluationSet.find(params[:id])
    @results =  @evaluation_set.results_by_question
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end
    respond_with(@results)
  end

  member_action :unlock, :method => :put do 
    es = EvaluationSet.find(params[:id])
    es.locked = false
    es.save!
    redirect_to admin_evaluation_set_path(es), :notice => "Unlocked!"
  end

  member_action :lock, :method => :put do 
    es = EvaluationSet.find(params[:id])
    es.locked = true
    es.save!
    redirect_to admin_evaluation_set_path(es), :notice => "Locked!"
  end

  controller do 
    before_filter :check_admin, :except => [:index, :show, :results]
    private
    def check_admin
      if !current_user.is_admin?
        boot_url = params[:id].nil? ? admin_evaluation_sets_url : admin_evaluation_set_url(params[:id])
        redirect_to boot_url, :notice => "Sorry, you don't have permission to do that."
      end
    end
  end


  #
  # Fix Action Buttons 
  #

  config.clear_action_items!

  action_item :only => :index do
    link_to "New Evaluation Set", new_admin_evaluation_set_path
  end  
    
  action_item :only => :show do
    if !evaluation_set.locked
      link_to "Edit", edit_admin_evaluation_set_path(evaluation_set)
    end
  end  

  action_item :only => :show do 
    link_to "View Results", results_admin_evaluation_set_path(evaluation_set)
  end

  action_item :only => :edit do
    link_to "Delete", admin_evaluation_set_path(evaluation_set),  :method => :delete, :confirm => "Are you READLLY SURE you want to delete this evaluation set?"
  end  

  action_item :only => :show do
    if evaluation_set.locked
      link_to unlock_admin_evaluation_set_path(evaluation_set), :method => :put do 
        image_tag "lock.png", :height=> "12"
      end
    else
      link_to lock_admin_evaluation_set_path(evaluation_set),  :method => :put do 
        image_tag "unlock.png", :height=> "12"
      end
    end
  end 

end
