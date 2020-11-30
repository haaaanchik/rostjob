module Cmd
  module UserActionLogger
    module ProposalEmployee
      module Interview
        class ByStaffer
          include Interactor

          delegate :user,              to: :context
          delegate :proposal_employee, to: :context

          def call
            Cmd::UserActionLogger::Log.call(params: logger_params)
          end

          private

          def receiver_ids
            [user.id, proposal_employee.profile.user.id]
          end

          def logger_params
            {
              login: user.name,
              receiver_ids: receiver_ids,
              subject_id: user.id,
              subject_type: 'Staffer',
              subject_role: user.role_list.first,
              action: "Кандидату #{proposal_employee.employee_cv.name} с анкетой №#{proposal_employee.employee_cv.id} назначена дата собеседования #{proposal_employee.interview_date.strftime('%d.%m.%Y')} администратором",
              object_id: proposal_employee.employee_cv.id,
              object_type: 'EmployeeCv',
              order_id: proposal_employee.order_id,
              employee_cv_id: proposal_employee.employee_cv_id
            }
          end
        end
      end
    end
  end
end