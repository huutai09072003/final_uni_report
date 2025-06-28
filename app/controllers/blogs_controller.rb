class BlogsController < ApplicationController
  before_action :authenticate_blogger!, only: [:create, :like, :destroy]

  def index
    blogs = Blog.includes(:blogger).joins(:blogger).merge(Blogger.all)  # joins để ransack được blogger fields

    blogs = blogs.status_approved

    q = blogs.ransack(params[:q])

    blogs = q.result(distinct: true).order(published_at: :desc)

    blogs = blogs.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      blogs: blogs.as_json(
        include: {
          blogger: {
            only: [:id, :username, :avatar_url]
          }
        },
        methods: [:thumbnail_url]
      ),
      pagination: {
        current_page: blogs.current_page,
        total_pages: blogs.total_pages,
        total_count: blogs.total_count,
        per_page: blogs.limit_value
      }
    }
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
          blogger: { only: [:id, :username] },
          blog_likes: { only: [:blogger_id] }
        },
        methods: [:thumbnail_url]
      )
    else
      render json: { error: 'Blog not found' }, status: :not_found
    end
  end

  def create
    @blog = current_blogger.blogs.build(blog_params)
    if @blog.save
      BlogMailer.pending_review_email(@blog).deliver_later
      render json: @blog.as_json(methods: [:thumbnail_url]), status: :created
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
  
  def destroy
    blog = current_blogger.blogs.find_by(id: params[:id])
    if blog
      blog.destroy
      render json: { message: 'Blog deleted successfully' }, status: :ok
    else
      render json: { error: 'Blog not found' }, status: :not_found
    end
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :content, :thumbnail, :published_at)
  end
end
