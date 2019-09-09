module Cmd
  module Api
    module BotCallback
      class ValidateRequest
        include Interactor

        def call
          contract = BotCallbackContract.new
          result = contract.call(bot_callback_params)
          if result.failure?
            messages = result.errors.to_h.map do |k, v|
              "#{k}: #{v.join(', ')}"
            end.join('; ')
            context.fail!(code: 422, message: messages)
          end

        end

        private

        def bot_callback_params
          {
            guid: input_params['guid'],
            candidate_id: input_params['candidate_id'],
            call_data: input_params['call_data']
          }
        end

        def input_params
          context.input_params
        end
      end
    end
  end
end
