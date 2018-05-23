class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{current_user_profile.id}"
  end

  def unsubscribed
  end
end
