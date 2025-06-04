class BlogsController < ApplicationController
  before_action :authenticate_blogger!, only: [:create, :like]

  def index
    blogs = Blog.includes(:blogger).status_approved.order(published_at: :desc)
    render json: blogs.as_json(include: { blogger: { only: [:id, :name, :avatar_url] } })
  end

  def top_bloggers
    bloggers = Blogger
      .joins(:blogs)
      .merge(Blog.status_approved)
      .group('bloggers.id')
      .select('bloggers.id, bloggers.username, COUNT(blogs.id) as blogs_count')
      .order('blogs_count DESC')
      .limit(5)

    render json: bloggers
  end

  def top_views
    blogs = Blog.status_approved.order(view_count: :desc).limit(5)
    render json: blogs.as_json(only: [:id, :title])
  end

  def show
    blog = Blog.status_approved.includes(:blogger, :blog_likes).find_by(id: params[:id])
    if blog
      blog.increment!(:view_count)
      render json: blog.as_json(
        include: {
          blogger: { only: [:id, :name, :avatar_url] },
          blog_likes: { only: [:blogger_id] }
        }
      )
    else
      render json: { error: 'Blog not found' }, status: :not_found
    end
  end

  def create
    @blog = current_blogger.blogs.build(blog_params)
    if @blog.save
      BlogMailer.pending_review_email(@blog).deliver_later
      render json: @blog, status: :created
    else
      render json: { errors: @blog.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /blogs/:id/like
  def like
    blog = Blog.find(params[:id])
    existing_like = blog.blog_likes.find_by(blogger: current_blogger)

    if existing_like
      existing_like.destroy
      blog.decrement!(:likes_count)
      render json: { liked: false, likes_count: blog.likes_count }
    else
      like = blog.blog_likes.build(blogger: current_blogger)
      if like.save
        blog.increment!(:likes_count)
        BlogMailer.liked_email(blog, current_blogger).deliver_later
        render json: { liked: true, likes_count: blog.likes_count }
      else
        render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :content, :thumb_nail_url, :published_at)
  end
end
