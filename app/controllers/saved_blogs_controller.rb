class SavedBlogsController < ApplicationController
  before_action :authenticate_blogger!
  before_action :set_blog

  def toggle
    saved = current_blogger.saved_blogs.find_by(blog: @blog)

    if saved
      saved.destroy
      render json: { saved: false }, status: :ok
    else
      current_blogger.saved_blogs.create!(blog: @blog)
      render json: { saved: true }, status: :created
    end
  end

  def index
    saved_blogs = current_blogger.saved_blog_posts.includes(:blogger)
    render json: saved_blogs.as_json(include: :blogger), status: :ok
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  end
end
