ActiveAdmin.register Bird do

  config.sort_order = 'name_asc'
  
  menu :priority => 10
  show :title => :name 

  scope :All, :default => true do |birds|
    birds.includes [:habitat, :genus_type ]
  end

  filter :habitat
  filter :genus_type, :label => "Classification"
  filter :fse_org_style, :label => "FSE Org. Style"
  filter :op_org_style, :label => "OP Org. Style"
  filter :birder_credits, :as => :string


  index do |f|
    column :logo do |b|
      b.logo.nil? ? "" : image_tag(b.logo.asset.url(:sq50));
    end
    column :name
    column "Habitat", :sortable => false do |b|
      link_to(b.habitat.name, admin_habitat_path(b.habitat)) unless b.habitat.nil?
    end
    column "Classification", :sortable => false do |b|
      link_to(b.genus_type.name, admin_genus_type_path(b.genus_type)) unless b.genus_type.nil?
    end 
  end
  
  show :title=> :name do
    panel "Basic Info" do
      attributes_table_for bird do
        row "#{I18n.translate!("boi_schema.fields.name.human")}" do |b| 
          b.name
        end
        row "#{I18n.translate!("boi_schema.fields.logo.human")}" do |b| 
          b.logo.nil? ? "" : image_tag(b.logo.asset.url(:sq300))
        end
        #row "#{I18n.translate!("boi_schema.fields.images.human")}" do |b| 
        #  render :partial => "/admin/assets/assets", :locals => {:assets => b.images}
        #end        
        row "#{I18n.translate!("boi_schema.fields.url.human")}" do |b| 
          b.url
        end
        row "#{I18n.translate!("boi_schema.fields.habitat.human")}" do |b| 
          link_to(b.habitat.name, admin_habitat_path(b.habitat)) unless b.habitat.nil?
        end      
        row "#{I18n.translate!("boi_schema.fields.genus_type.human")}" do |b| 
          link_to(b.genus_type.name, admin_genus_type_path(b.genus_type)) unless b.genus_type.nil?
        end    
        row "#{I18n.translate!("boi_schema.fields.brand.human")}" do |b| 
          simple_format b.brand
        end 
      end 
    end
    
    panel "Structure" do
      attributes_table_for bird do
        #FSE
        row "#{I18n.translate!("boi_schema.fields.fse_name.human")}" do |b| 
          simple_format b.fse_name
        end
        row "#{I18n.translate!("boi_schema.fields.fse_org_style.human")}" do |b| 
          link_to(b.fse_org_style.name, admin_org_style_path(b.fse_org_style)) unless b.fse_org_style.nil?
        end
        row "#{I18n.translate!("boi_schema.fields.fse_owner_founder.human")}" do |b| 
          simple_format b.fse_owner_founder
        end        
        row "#{I18n.translate!("boi_schema.fields.fse_significant_member.human")}" do |b| 
          simple_format b.fse_significant_member
        end
        row "#{I18n.translate!("boi_schema.fields.fse_mission_statement.human")}" do |b| 
          simple_format b.fse_mission_statement
        end
        # OP
        row "#{I18n.translate!("boi_schema.fields.op_name.human")}" do |b| 
          simple_format b.op_name
        end
        row "#{I18n.translate!("boi_schema.fields.op_org_style.human")}" do |b| 
          link_to(b.op_org_style.name, admin_org_style_path(b.op_org_style)) unless b.op_org_style.nil?
        end
        row "#{I18n.translate!("boi_schema.fields.op_vip_founders.human")}" do |b| 
          simple_format b.op_vip_founders
        end        
        row "#{I18n.translate!("boi_schema.fields.op_typical_member.human")}" do |b| 
          simple_format b.op_typical_member
        end 
        row "#{I18n.translate!("boi_schema.fields.foritself.human")}" do |b| 
          simple_format b.foritself
        end           
      end 
    end    

    panel "Ontogeny" do
      attributes_table_for bird do
        row "#{I18n.translate!("boi_schema.fields.formation.human")}" do |b| 
          simple_format b.formation
        end   
        row "#{I18n.translate!("boi_schema.fields.history.human")}" do |b| 
          simple_format b.history
        end
        row "#{I18n.translate!("boi_schema.fields.lifespan.human")}" do |b| 
          simple_format b.lifespan
        end                   
      end
    end
    
    panel "Behavior" do
      attributes_table_for bird do
        row "#{I18n.translate!("boi_schema.fields.resource.human")}" do |b| 
          simple_format b.resource
        end   
        row "#{I18n.translate!("boi_schema.fields.availability.human")}" do |b| 
          simple_format b.availability
        end
        row "#{I18n.translate!("boi_schema.fields.participation.human")}" do |b| 
          simple_format b.participation
        end
        row "#{I18n.translate!("boi_schema.fields.tasks.human")}" do |b| 
          simple_format b.tasks
        end        
         row "#{I18n.translate!("boi_schema.fields.modularity.human")}" do |b| 
          simple_format b.modularity
        end       
        row "#{I18n.translate!("boi_schema.fields.granularity.human")}" do |b| 
          simple_format b.granularity
        end
        row "#{I18n.translate!("boi_schema.fields.metrics.human")}" do |b| 
          simple_format b.metrics
        end
        row "#{I18n.translate!("boi_schema.fields.tangible_problem.human")}" do |b| 
          "#{b.tangible_problem}. #{b.tangible_problem_detail}"
        end        
                        
      end
    end    
    
    
    panel "Mating" do
      attributes_table_for bird do
        row "#{I18n.translate!("boi_schema.fields.alliances.human")}" do |b| 
          simple_format b.alliances
        end   
        row "#{I18n.translate!("boi_schema.fields.clients.human")}" do |b| 
          simple_format b.clients
        end
        row "#{I18n.translate!("boi_schema.fields.sponsors.human")}" do |b| 
          simple_format b.sponsors
        end
        row "#{I18n.translate!("boi_schema.fields.elites.human")}" do |b| 
          simple_format b.elites
        end        
      end
    end    
    
     panel "Summary" do
      attributes_table_for bird do
        row "" do |b| 
          simple_format b.summary
        end         
      end
    end     
    
      panel "Metadata" do
      attributes_table_for bird do
        row "#{I18n.translate!("boi_schema.fields.birder_credits.human")}" do |b| 
          simple_format b.birder_credits
        end  
        row :created_at do |b|
          b.created_at.localtime unless b.created_at.nil?
        end
        row :updated_at do |b|
          b.updated_at.localtime unless b.updated_at.nil?
        end
        row "Last Updated By" do |b| 
          b.updated_by.email unless b.updated_by.nil?
        end         
      end
    end     
    
  end
  
  
  form :partial => "form"
  
  
  sidebar :last_saved, :except => [:index, :show] do 
    render :partial => "admin/birds/save_sidebar"
  end
  
  sidebar "Attached Files", :only => [:show] do
    if bird.images.empty?
      span(:class=> "empty_field") do
        "empty"
      end
    else
      render :partial => "admin/assets/assets", :locals => {:assets => bird.images}
    end
  end
  
  controller do
    before_filter :only => :index do 
      @per_page = 9999 
    end  
    def update
      update! do |format|
        format.html do
          if request.xhr?
            render :partial => "form"
          else
            redirect_to admin_bird_path(@bird)
          end
        end
      end
    end
  end 
  
  # Fix Action Buttons 
  config.clear_action_items!
  
  action_item :only => :index do
    link_to "New Bird", new_admin_bird_path
  end  
    
  action_item :only => :show do
    link_to "Edit", edit_admin_bird_path(bird)
  end  

  action_item :only => :show do
    link_to "Evaluate this bird", new_admin_user_evaluation_path(:bird => bird), :target => "_blank"
  end

  action_item :only => :new do
    link_to "Cancel", admin_birds_path
  end 

  action_item :only => :edit do
    link_to "Cancel", admin_bird_path(bird)
  end 


  action_item :only => :edit do
    link_to "Delete", admin_bird_path(bird), :method => :delete, :confirm => "Are you really sure you want to delete this bird?"
  end    
  
  
end
