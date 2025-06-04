class ResultsController < ApplicationController
  def index
    results = Result.all
    render json: results
  end

  def create
    result = Result.new(result_params)
    if result.save
      render json: result, status: :created
    else
      render json: result.errors, status: :unprocessable_entity
    end
  end

  private

  def result_params
    params.require(:result).permit(:user_selection, :ai_prediction, :correct)
  end
end