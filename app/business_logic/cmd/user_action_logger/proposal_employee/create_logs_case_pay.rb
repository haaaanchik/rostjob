module Cmd

  module UserActionLogger
    module ProposalEmployee
      class CreateLogsCasePay
        include Interactor

        delegate :log,       to: :context
        delegate :candidate, to: :context

        def call
          return unless log
          Cmd::UserActionLogger::Log.call(params: customer_params)
        end

        private

        def customer
          @customer = candidate.order.user
        end

        def action
          "Акт по анкете №#{candidate.employee_cv_id} #{candidate.employee_cv.name} подтвержден"
        end

        def customer_params
          {
            login: customer.email,
            receiver_ids: [customer.id],
            subject_id: customer.id,
            subject_type: 'User',
            subject_role: customer.profile.profile_type,
            action: action,
            object_id: candidate.id,
            object_type: 'ProposalEmployee',
            employee_cv_id: candidate.employee_cv_id,
            order_id: candidate.order_id
          }
        end
      end
    end
  end
end
