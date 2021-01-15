# frozen_string_literal: true

module Cmd
  module Api
    module BotCallback
      class Create
        include Interactor

        delegate :guid, to: :context
        delegate :name, to: :context
        delegate :phone, to: :context

        def call
          context.fail!(code: 422, message: 'Contractor not found!') if user.blank?

          cb = ::BotCallback.create(bot_callback_params)
          context.fail!(code: 422, message: cb.errors.messages) if cb.invalid?

          Cmd::FreeManager::Remove.call(user_id: user.id)
          context.profile_id = user.profile.id
        end

        private

        def bot_callback_params
          {
            guid: guid,
            candidate_id: user.id,
            call_data: "Номер телефона: #{phone}"
          }
        end

        def user
          @user ||= User.joins(:profile).find_by(guid: guid, 'profiles.profile_type': 'contractor')
        end
      end
    end
  end
end
