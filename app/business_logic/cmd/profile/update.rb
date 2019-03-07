module Cmd
  module Profile
    class Update
      include Interactor

      def call
        binding.pry
        profile.assign_attributes(profile_params.except(:profile_type, :legal_form))
        if company?
          profile.save(context: :company)
        else
          profile.save
        end
        context.failed! if profile.errors.messages.any?
        Cmd::UserActionLogger::Log.call(params: logger_params) unless context.log == false
      end

      private

      def new_profile_params
        profile_params[:company_attributes].merge!(legal_form: legal_form)
        profile_params
      end

      def legal_form
        profile.legal_form
      end

      def profile_params
        context.params
      end

      def profile
        context.profile
      end

      def company?
        profile_params[:legal_form] == 'company'
      end

      def logger_params
        {
          receiver_ids: [profile.user.id],
          subject_id: profile.user.id,
          subject_type: 'User',
          subject_role: profile.profile_type,
          action: 'Профиль обновлён',
          object_id: profile.id,
          object_type: 'Profile'
        }
      end
    end
  end
end
