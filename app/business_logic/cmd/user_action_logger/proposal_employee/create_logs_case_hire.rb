module Cmd
  module UserActionLogger
    module ProposalEmployee
      class CreateLogsCaseHire
        include Interactor

        delegate :candidate, to: :context

        def call
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def user
          context.user || candidate.order.user
        end

        def admin?
          @admin ||= user.is_a?(Staffer)
        end

        def login
          admin? ? user.login : candidate.user.email
        end

        def subject_role
          admin? ? user.staffer_roles.last : candidate.profile.profile_type
        end

        def subject_type
          admin? ? 'Staffer' : 'User'
        end

        def action
          text = "Кандидат #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} нанят"
          text.concat(' администратором.') if admin?

          text
        end

        def receiver_ids
          [user.id, candidate.user.id]
        end

        def logger_params
          {
            login: login,
            receiver_ids: receiver_ids,
            subject_id: user.id,
            subject_type: subject_type,
            subject_role: subject_role,
            action: action,
            object_id: candidate.employee_cv.id,
            object_type: 'EmployeeCv',
            order_id: candidate.order_id,
            employee_cv_id: candidate.employee_cv_id
          }
        end
      end
    end
  end
end