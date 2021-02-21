# frozen_string_literal: true

module Cmd
  module NotifyMail
    module Order
      module Moderate
        class NotifyCustomer
          include Interactor

          delegate :order, to: :context

          def call
            return unless order.profile.notify_mails?

            OrderMailJob.perform_now(order: order, method: 'moderated')
          end
        end
      end
    end
  end
end
