module Cmd
  module ProposalEmployee
    module Approve
      class UpdateDeposit
        include Interactor

        delegate :candidate, to: :context

        def call
          description = "Вознаграждение по заявке №#{order.id}, за кандидата №#{candidate.employee_cv_id} #{employee_cv.name}"
          context.fail! unless profile.balance.deposit(amount, description)
        end

        private

        def profile
          candidate.profile
        end

        def order
          candidate.order
        end

        def employee_cv
          candidate.employee_cv
        end

        def amount
          order.contractor_price
        end
      end
    end
  end
end
