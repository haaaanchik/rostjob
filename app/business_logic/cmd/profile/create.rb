module Cmd
  module Profile
    class Create
      include Interactor

      delegate :user, to: :context
      delegate :profile_params, to: :context

      def call
        @profile = user.build_profile(profile_params)
        if company?
          @profile.save(context: :company)
        else
          @profile.save
        end
        context.profile = @profile
        context.failed! if @profile.errors.messages.any?
        Cmd::User::Registration::Update.call(user: user, params: { profile_id: @profile.id }, log: false)
        Cmd::UserActionLogger::Log.call(params: logger_params) if log
      end

      private

      def log
        context.log || false
      end

      def company?
        profile_params[:legal_form] == 'company'
      end

      def logger_params
        {
          login: user.email,
          receiver_ids: [user.id],
          subject_id: user.id,
          subject_type: 'User',
          subject_role: user.profile.profile_type,
          action: 'Профиль создан',
          object_id: @profile.id,
          object_type: 'Profile'
        }
      end
    end
  end
end
