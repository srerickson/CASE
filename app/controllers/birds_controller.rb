class BirdsController < ApplicationController
  respond_to :json

  def show
    respond_with Bird.find(params[:id]), root: false 
  end

  def index
    respond_with Bird.all, root: false, :each_serializer => BirdArraySerializer
  end

end