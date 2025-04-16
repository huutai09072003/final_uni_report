class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel_user_#{current_user.id}"
  end
end