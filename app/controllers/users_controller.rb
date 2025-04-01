class UsersController < ApplicationController
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:show, :edit, :update]

  def show
    @user = current_user
    render inertia: 'User/Show', props: {
      user: @user.as_json(only: [:id, :email, :name, :location, :points, :role, :recycling_goal])
    }
  end

  def edit

    @user = current_user
    render inertia: 'User/Edit', props: {
      user: @user.as_json(only: [:id, :email, :name, :location, :points, :role, :recycling_goal])
    }
  end

  def update
    @user = current_user

    if @user.update(user_params)
      respond_to do |format|
        format.html do
          flash[:notice] = 'Account updated successfully!'
          render inertia: 'User/Show', props: {
            user: @user.as_json(only: [:id, :email, :name, :location, :points, :role, :recycling_goal])
          }
        end
        format.json do
          render json: { success: true, user: @user.slice(:id, :email, :name, :location, :points, :role, :recycling_goal) }
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :location, :recycling_goal, :role)
  end
end
