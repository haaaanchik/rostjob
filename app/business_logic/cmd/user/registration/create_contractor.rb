module Cmd
  module User
    module Registration
      class CreateContractor
        include Interactor

        def call
          result = ::Cmd::User::Registration::Create.call(user_params: context.user_params, log: false)
          @user = result.user
          context.user = result.user
          context.fail! unless result.success?
          result = ::Cmd::Profile::Create.call(user: @user, params: profile_params, log: false)
          context.fail! unless result.success?
          profile = result.profile
          result = ::Cmd::Profile::Balance::Create.call(profile: profile)
          context.fail! unless result.success?
          result = ::Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: profile, legal_form: 'company')
          context.fail! unless result.success?
          result = ::Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: profile, legal_form: 'ip')
          context.fail! unless result.success?
          result = ::Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: profile, legal_form: 'private_person')
          context.fail! unless result.success?
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def profile_params
          {
            profile_type: 'contractor'
          }
        end

        def logger_params
          {
            login: @user.email,
            receiver_ids: [@user.id],
            subject_id: @user.id,
            subject_type: 'User',
            subject_role: @user.profile ? @user.profile.profile_type : nil,
            action: "Создана учетная запись исполнителя #{@user.email}",
            object_id: @user.id,
            object_type: 'User'
          }
        end
      end
    end
  end
end
