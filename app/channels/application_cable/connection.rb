module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_profile

    def connect
      self.current_user_profile = find_verified_user_profile
    end

    private

    def find_verified_user_profile
      session_key = Rails.application.config.session_options[:key]
      session_data = cookies.encrypted[session_key]
      warden_data = session_data["warden.user.user.key"]
      user_id = warden_data[0][0]

      if verified_user = User.find_by(id: user_id)
        verified_user.profile
      else
        reject_unauthorized_connection
      end
    end
  end
end
