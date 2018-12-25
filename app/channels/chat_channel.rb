class ChatChannel < ApplicationCable::Channel
  def subscribed
    return unless current_user_profile
    stream_from "chat_channel_#{current_user_profile.id}"
  end

  def unsubscribed
  end
end
