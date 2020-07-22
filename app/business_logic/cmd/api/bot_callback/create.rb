module Cmd
  module Api
    module BotCallback
      class Create
        include Interactor

        delegate :input_params, to: :context

        def call
          cb = ::BotCallback.create(bot_callback_params)
          context.fail!(code: 422, message: cb.errors.messages) if cb.invalid?
          Cmd::FreeManager::Remove.call(user_id: user.id)
          context.profile_id = user.profile.id
        end

        private

        def bot_callback_params
          {
            guid: input_params[:guid],
            candidate_id: input_params[:name],
            call_data: "Номер телефона: #{input_params[:phone]}"
          }
        end

        def user
          @user ||= ::User.find_by(guid: input_params[:guid])
        end
      end
    end
  end
end
