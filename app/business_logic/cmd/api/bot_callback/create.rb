module Cmd
  module Api
    module BotCallback
      class Create
        include Interactor

        def call
          cb = ::BotCallback.create(bot_callback_params)
          context.callback = cb
          context.fail!(code: 422, message: cb.errors.messages) if cb.invalid?
          ActionCable.server.broadcast("bot_channel_#{profile.id}",
                                       employee_cv_url: "/bots/employee_cvs/#{candidate_id}")
        end

        private

        def bot_callback_params
          {
            guid: input_params['guid'],
            candidate_id: input_params['candidate_id'],
            call_data: input_params['call_data']
          }
        end

        def candidate_id
          input_params[:candidate_id]
        end

        def profile
          user.profile
        end

        def user
          ::User.find_by(guid: input_params['guid'])
        end

        def input_params
          context.input_params
        end
      end
    end
  end
end
