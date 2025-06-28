class BloggersController < ApplicationController
  before_action :authenticate_blogger!
  before_action :set_blogger
  before_action :authorize_owner!, include: [:update, :liked_blogs, :saved_blogs, :commented_blogs]

  # GET /bloggers
  def index
    @bloggers = Blogger.all
    render json: @bloggers, status: :ok
  end

  # GET /bloggers/:id
  def show
    @blogs = @blogger.blogs
    render json: @blogger.as_json.merge(blogs: @blogs.map { |b| b.as_json.merge(thumbnail_url: b.thumbnail_url) })
  end

  # PATCH/PUT /bloggers/:id
  def update
    if @blogger.update(blogger_params)
      render json: @blogger, status: :ok
    else
      render json: { errors: @blogger.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def liked_blogs
    blogs = Blog.status_approved
                .joins(:blog_likes)
                .where(blog_likes: { blogger_id: @blogger.id })
                .distinct

    render json: blogs.as_json(
      only: [:id, :title, :status, :created_at],
      methods: [:thumbnail_url]
    ), status: :ok
  end

  def saved_blogs
    blogs = @blogger.saved_blog_posts.status_approved.distinct

    render json: blogs.as_json(
      only: [:id, :title, :status, :created_at],
      methods: [:thumbnail_url]
    ), status: :ok
  end

  def commented_blogs
    blogs = Blog.status_approved
                .joins(:comments)
                .where(comments: { blogger_id: @blogger.id })
                .distinct

    render json: blogs.as_json(
      only: [:id, :title, :status, :created_at],
      methods: [:thumbnail_url]
    ), status: :ok
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

  def authorize_owner!
    unless current_blogger == @blogger
      render json: { error: "Bạn không có quyền truy cập." }, status: :forbidden
    end
  end
end
