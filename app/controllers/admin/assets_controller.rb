class Admin::AssetsController < ApplicationController

  before_filter :get_bird

  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id], :include => :user)
    @total_assets = Asset.find(:all, :conditions => { :user_id => @asset.user.id})
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.xml
  def create
      @bird
      newparams = coerce(params)
      @asset = Asset.new(newparams[:asset])
      if @asset.save
        flash[:notice] = "Successfully created asset."
        respond_to do |format|
          format.all {
            render :partial => "admin/assets/form.html.erb", :locals => {:assets => @bird.images, :attached_to => @bird }
          }
          #format.json {
          #  render :json => { :result => 'success', :asset => asset_path(@asset) } 
          #}
        end
      else
        render :action => 'new'
      end
    end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])
    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html { redirect_to(@asset, :notice => 'Asset was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => "admin/birds/form"
        else
          redirect_to admin_edit_bird_url(@bird)
        end
      }
      format.xml  { head :ok }
    end
  end

  private 
  
  def get_bird
    @bird = Bird.find(params[:bird_id])
  end

  def coerce(params)
    if params[:upload].nil? 
      h = Hash.new 
      h[:asset] = Hash.new 
      h[:asset][:attached_to] = @bird
      h[:asset][:asset] = params[:Filedata] 
      h[:asset][:asset].content_type = MIME::Types.type_for(h[:asset][:asset].original_filename).to_s
      h
    else 
      params
    end 
  end
  

end
