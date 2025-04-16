class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    render inertia: 'Notification/Index', props: {
      notifications: @notifications.as_json
    }
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)

    render json: { success: true }
  end
end