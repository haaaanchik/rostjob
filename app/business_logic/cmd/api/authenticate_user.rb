module Cmd
  module Api
    class AuthenticateUser
      include Interactor

      def call
        contract = AuthContract.new
        result = contract.call(api_token: api_token)
        if result.failure?
          messages = result.errors.to_h.map do |k, v|
            "#{k}: #{v.join(', ')}"
          end.join('; ')
          context.fail!(code: 401, message: "Authentication Required. #{messages}")
        end
        context.fail!(code: 401, message: "Authentication Required. User unknown.") unless api_user_authenticated?
      end

      private

      def input_params
        context.input_params
      end

      def api_token
        input_params[:api_token]
      end

      def api_user_authenticated?
        Rails.configuration.vocamate['api_token'] == api_token
      end
    end
  end
end
