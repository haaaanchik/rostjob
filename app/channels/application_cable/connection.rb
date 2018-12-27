module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user_profile

    def connect
      self.current_user_profile = find_verified_user_profile
    end

    protected

    def find_verified_user_profile
      verified_user = env['warden'].user
      if verified_user
        verified_user.profile
      else
        reject_unauthorized_connection
      end
    end
  end
end
