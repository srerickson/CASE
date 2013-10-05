class EvaluationSetsController < ApplicationController

  respond_to :json, :html

  def show
    @id = params[:id]
    respond_with do |format|
      format.json{ respond_with EvaluationSet.find(params[:id]), root: false }
    end 
    
  end

end