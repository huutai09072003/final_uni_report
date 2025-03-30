class UsersController < ApplicationController
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
      flash[:notice] = 'Account updated successfully!'
      redirect_to user_path and return
    else
      render inertia: 'User/Edit', props: {
        user: @user.as_json(only: [:id, :email, :name, :location, :points, :role, :recycling_goal]),
        errors: @user.errors.messages,
        flash: flash.to_hash
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :location, :recycling_goal)
  end
end