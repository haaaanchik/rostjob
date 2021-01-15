# frozen_string_literal: true

module Api
  module V1
    module Auth
      def user_authenticated?
        return if request_is_valid?

        raise Errors.new(text: 'Invalid API-token or IP-address',
                         code: 2010,
                         status: 401)
      end

      private

      def api_key
        @api_key ||= ApiKey.find_by(token: headers['Authorization'])
      end

      def request_is_valid?
        api_key.present? &&
          api_key.split(',').include?(request.ip)
      end

      def headers
        request.headers
      end
    end
  end
end
