# frozen_string_literal: true

module Api
  module V1
    module Auth
      def user_authenticated!
        return if request_is_valid?

        raise Errors.new(text: 'Invalid Bearer API-token',
                         status: 401)
      end

      private

      def api_key
        @api_key ||= ApiKey.find_by(token: token)
      end

      def request_is_valid?
        Rails.env.development? ||
          (api_key.present? &&
            api_key.active?)
      end

      def headers
        request.headers
      end

      def token
        @token ||= headers['Authorization'].gsub(/Bearer /, '') rescue nil
      end
    end
  end
end
