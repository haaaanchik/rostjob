# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Order
      module Moderate
        class NotifyAdmin
          include Interactor

          delegate :order, to: :context

          def call
            OrderMailJob.perform_now(admin: ['spb@rostjob.com', 'manager@rostjob.com'],
                                     method: 'moderated',
                                     order: order)

          end

        end
      end
    end
  end
end
