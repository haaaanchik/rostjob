module Cmd
  module User
    module Registration
      class CreateCustomer
        include Interactor

        def call
          result = ::Cmd::User::Registration::Create.call(user_params: context.user_params, log: false)
          @user = result.user
          context.user = result.user
          context.fail! unless result.success?
          result = ::Cmd::Profile::Create.call(user: @user, params: profile_params, log: false)
          @profile = result.profile
          context.fail! unless result.success?
          result = ::Cmd::Profile::Balance::Create.call(profile: result.profile)
          context.fail! unless result.success?
          ::CreateDemoDataJob.perform_later(profile: @profile) if Rails.env.development? || Rails.env.demo?
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def profile_params
          {
            profile_type: 'customer',
            legal_form: 'company'
          }
        end

        def logger_params
          {
            login: @user.email,
            receiver_ids: [@user.id],
            subject_id: @user.id,
            subject_type: 'User',
            subject_role: @user.profile ? @user.profile.profile_type : nil,
            action: "Создана учетная запись заказчика #{@user.email}",
            object_id: @user.id,
            object_type: 'User'
          }
        end
      end
    end
  end
end
