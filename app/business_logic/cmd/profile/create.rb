module Cmd
  module Profile
    class Create
      include Interactor

      def call
        @profile = current_user.build_profile(profile_params)
        if company?
          @profile.save(context: :company)
        else
          @profile.save
        end
        context.profile = @profile
        context.failed! if @profile.errors.messages.any?
        Cmd::User::Registration::Update.call(user: current_user, params: { profile_id: @profile.id }, log: false)
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def profile_params
        context.params
      end

      def current_user
        context.user
      end

      def company?
        profile_params[:legal_form] == 'company'
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: 'Профиль создан',
          object_id: @profile.id,
          object_type: 'Profile'
        }
      end
    end
  end
end
