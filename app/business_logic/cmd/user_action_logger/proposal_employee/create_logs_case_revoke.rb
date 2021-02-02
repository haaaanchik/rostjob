module Cmd
  module UserActionLogger
    module ProposalEmployee
      class CreateLogsCaseRevoke
        include Interactor

        delegate :user, to: :context
        delegate :proposal_employee, to: :context

        def call
          ::Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def receiver_ids
          [user.id, proposal_employee.order.profile.user.id]
        end

        def action
          text = "Анкета №#{proposal_employee.employee_cv.id} #{proposal_employee.employee_cv.name} отозвана "

          return text.concat('администратором') if user.is_a?(Staffer)

          role = user.profile.customer? ? 'заказчиком' : 'исполнителем'
          text.concat(role)
        end

        def admin?
          @admin = user.is_a?(Staffer)
        end

        def subject_role
          admin? ? user.role_list.first : user.profile.profile_type
        end

        def login
          admin? ? user.login : user.email
        end

        def logger_params
          {
            login: login,
            receiver_ids: receiver_ids,
            subject_id: user.id,
            subject_type: user.class.to_s,
            subject_role: subject_role,
            action: action,
            object_id: proposal_employee.id,
            object_type: 'ProposalEmployee',
            order_id: proposal_employee.order_id,
            employee_cv_id: proposal_employee.employee_cv_id
          }
        end
      end
    end
  end
end