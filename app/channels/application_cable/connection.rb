module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_profile

    def connect
      # self.current_user_profile = find_verified_user_profile
    end

    private

    def find_verified_user_profile
      session_key = Rails.application.config.session_options[:key]
      session_data = cookies.encrypted[session_key]
      warden_data = session_data["warden.user.user.key"] || []
      in_warden_data = warden_data[0] || []
      user_id = in_warden_data[0]
      verified_user = User.find_by(id: user_id)

      if verified_user
        verified_user.profile
      else
        reject_unauthorized_connection
      end
    end
  end
end
