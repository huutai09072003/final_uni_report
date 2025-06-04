class BloggersController < ApplicationController
  before_action :authenticate_blogger!
  before_action :set_blogger, only: [:show, :update]

  # GET /bloggers
  def index
    @bloggers = Blogger.all
    render json: @bloggers, status: :ok
  end

  # GET /bloggers/:id
  def show
    render json: @blogger, status: :ok
  end

  # PATCH/PUT /bloggers/:id
  def update
    if @blogger.update(blogger_params)
      render json: @blogger, status: :ok
    else
      render json: { errors: @blogger.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_blogger
    @blogger = Blogger.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Blogger not found' }, status: :not_found
  end

  def blogger_params
    params.require(:blogger).permit(:username, :email, :password, :password_confirmation)
  end
end
