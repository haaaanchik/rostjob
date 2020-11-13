module Cmd
  module UserActionLogger
    module ProposalEmployee
      class CreateLogCaseInterview
        include Interactor

        delegate :user,      to: :context
        delegate :candidate, to: :context

        def call
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def user?
          @is_user = user.is_a?(User)
        end

        def login
          user? ? user.email : user.name
        end

        def receiver_ids
          [user.id, candidate.profile.user.id]
        end

        def subject_role
          user? ? user.profile.profile_type : user.role_list.first
        end

        def action_by
          return 'администратором' unless user?

          user.profile.customer? ? 'заказчиком' : 'исполнителем'
        end

        def logger_params
          {
            login: login,
            receiver_ids: receiver_ids,
            subject_id: user.id,
            subject_type: user.class.name,
            subject_role: subject_role,
            action: "Кандидату #{candidate.employee_cv.name} с анкетой №#{candidate.employee_cv.id} назначена дата собеседования #{candidate.interview_date.strftime('%d.%m.%Y')} #{action_by}",
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