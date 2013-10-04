class EvaluationSetsController < ApplicationController

  respond_to :json

  def show
    respond_with EvaluationSet.find(params[:id]), root: false
  end

end