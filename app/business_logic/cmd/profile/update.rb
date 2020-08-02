module Cmd
  module Profile
    class Update
      include Interactor

      delegate :profile, to: :context

      def call
        profile.assign_attributes(profile_params.except(:profile_type, :legal_form))
        if company?
          saved = profile.save(context: :company)
          send_welcome_message(saved)
        else
          profile.save
        end
        context.fail! if profile.errors.messages.any?
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

      def company?
        if profile.persisted?
          profile.legal_form == 'company'
        else
          profile_params[:legal_form] == 'company'
        end
      end

      def send_welcome_message(saved)
        return unless profile.customer? && saved

        SendDirectMailJob.perform_now(user: profile.user, method: 'welcome_message')
      end

      def logger_params
        {
          login: profile.user.email,
          receiver_ids: [profile.user.id],
          subject_id: profile.user.id,
          subject_type: 'User',
          subject_role: profile.profile_type,
          action: "Учётная запись #{profile.user.email} обновлена",
          object_id: profile.id,
          object_type: 'Profile'
        }
      end
    end
  end
end
