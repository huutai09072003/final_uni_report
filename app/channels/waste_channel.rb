class WasteChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id] || current_user&.id
    stream_from "waste_channel_user_#{user_id}"
  end
end
