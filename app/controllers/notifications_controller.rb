class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = current_user.notifications.order(created_at: :desc)

    render json: notifications.map { |n| serialize_notification(n) }
  end

  def update
    notification = current_user.notifications.find(params[:id])
    if notification.update(read: true)
      render json: { success: true }
    else
      render json: { success: false, errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def serialize_notification(notification)
    {
      id: notification.id,
      title: notification.title,
      body: notification.body,
      read: notification.read,
      created_at: notification.created_at.strftime('%Y-%m-%d %H:%M:%S')
    }
  end
end