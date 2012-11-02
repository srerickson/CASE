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
      div link_to("Results", results_table_admin_evaluation_set_path(es), :class=>"member_link")
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
            "#{ "------- " if q.sub_question? }#{q.to_s}"
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
      q.input :sub_question, :label => "sub question?"
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

  member_action :results_table, :method => :get do 

    @evaluation_set  = EvaluationSet.find(params[:id])
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end

    new_params = cleanup_result_search_params(params[:search])
    params[:search] = new_params
    @custom_sort = parse_result_custom_sort_params(params[:search])

    @evaluation_results =  @evaluation_set.evaluation_results.includes([:bird,:evaluation_question])

    if @custom_sort.empty?
      @evaluation_results  = @evaluation_results.order("birds.name ASC").search(params[:search])
    else
      @evaluation_results = @evaluation_results.search(params[:search])
    end

    @result_rows = EvaluationResultRow.build_results_table_by_bird(@evaluation_results)

    do_custom_sort(@custom_sort, @result_rows)

  end



  member_action :result_groups, :method => :get do 
    @evaluation_set = EvaluationSet.find(params[:id])
    @result_groups =  @evaluation_set.response_groups    
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end
  end



  member_action :results_twoaxis, :method => :get do 
    @evaluation_set = EvaluationSet.find(params[:id])
    if !current_user.is_admin? and !@evaluation_set.visible_results
      redirect_to admin_evaluation_set_path(@evaluation_set), :notice => "Sorry, these results are not public yet."
    end

    @results = EvaluationResultRow.build_results_table_by_question( 
                  @evaluation_set.evaluation_results
                    .includes([:bird,:evaluation_question])
                    .order("evaluation_questions.id ASC, birds.name ASC") )


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
    before_filter :check_admin, :except => [:index, :show , :results_table]
    private
    def check_admin
      if !current_user.is_admin?
        boot_url = params[:id].nil? ? admin_evaluation_sets_url : admin_evaluation_set_url(params[:id])
        redirect_to boot_url, :notice => "Sorry, you don't have permission to do that."
      end
    end

    protected

    # clean up the checkbox inputs from results search table
    def cleanup_result_search_params(search_params = [])
      if search_params
        [:evaluation_question_id_in, :bird_id_in].each do |key|
          if search_params[key].is_a? Array
            search_params[key].delete("")
            search_params[key] = [] if search_params[key].include?("0")
          end
        end
      end
      return search_params
    end

    def do_custom_sort(custom_sort, result_rows)
      if !@custom_sort.empty?
        case @custom_sort[:type]
          when :result_column
            @result_rows.sort_by! {  |r| 
              result = r.results[@custom_sort[:index]]
              score = result.answer_score * ( @custom_sort[:order] == :asc ? 1 : -1 ) 
              num_responses = (result.yes_count + result.no_count + result.na_count)
              #return [score, num_responses]
              [score, num_responses*(-1)]
            }
          when :by_summary
            @result_rows.sort_by!{ |r| 
              score = r.summary["score"] * ( @custom_sort[:order] == :asc ? 1 : -1 ) 
              num_responses = (r.summary["yes_count"] + r.summary["no_count"] + r.summary["na_count"])
              [score,num_responses*(-1)]
            }
        end
      end
    end


    def parse_result_custom_sort_params(search_params = [])
      custom_sort = {}      
      if search_params and search_params[:meta_sort]
        parse_custom_sort = search_params[:meta_sort].match(/custom_sort_([a-z_]*)(\[(\d+)\])?\.(.*)/)
        if parse_custom_sort
          custom_sort[:type]  = parse_custom_sort[1].to_sym
          custom_sort[:index] = parse_custom_sort[3].to_i
          custom_sort[:order] = parse_custom_sort[4].to_sym
        end
      end
      return custom_sort
    end

  end # controller do


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
    link_to "View Results", results_table_admin_evaluation_set_path(evaluation_set)
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
