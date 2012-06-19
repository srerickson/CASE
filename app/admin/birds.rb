ActiveAdmin.register Bird do
  
  index do |f|
    column :name
    default_actions
  end
  
  form :partial => "form"

  # for uploadify
  member_action :multi_upload, :method => :post do
    #newparams = coerce(params)
    @asset = Asset.new(newparams[:asset])
    if @asset.save
      flash[:notice] = "Successfully created asset."
      respond_to do |format|
        format.all {
          render :partial => "assets/form.html.erb", :locals => {:assets => @bird.images, :attached_to => @bird }
        }
      end
    else
      render :action => 'new'
    end

  end
end
