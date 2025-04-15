class WasteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "waste_channel_user_#{current_user.id}"
  end
end
