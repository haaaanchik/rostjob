class ChatChannel < ApplicationCable::Channel
  def subscribed
    #TODO FIX THIS
    # stream_from "chat_channel_#{current_user.profile.id}"
  end

  def unsubscribed
  end
end
