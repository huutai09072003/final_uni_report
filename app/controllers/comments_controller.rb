class CommentsController < ApplicationController
  before_action :authenticate_blogger!, only: [:create, :update, :destroy]
  before_action :set_blog
  before_action :set_comment, only: [:update, :destroy]

  def index
    comments = @blog.comments.includes(:blogger).order(created_at: :asc)
    render json: comments.as_json(include: { blogger: { only: [:id, :username, :avatar_url] } })
  end

  def create
    comment = @blog.comments.build(comment_params.merge(blogger: current_blogger))
    if comment.save
      render json: comment.as_json(include: { blogger: { only: [:id, :username, :avatar_url] } }), status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.blogger == current_blogger
      if @comment.update(comment_params)
        render json: @comment.as_json(include: { blogger: { only: [:id, :username, :avatar_url] } })
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Bạn không có quyền cập nhật bình luận này.' }, status: :forbidden
    end
  end

  def destroy
    if @comment.blogger == current_blogger
      @comment.destroy
      render json: { success: true }
    else
      render json: { error: 'Bạn không có quyền xoá bình luận này.' }, status: :forbidden
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def set_comment
    @comment = @blog.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
