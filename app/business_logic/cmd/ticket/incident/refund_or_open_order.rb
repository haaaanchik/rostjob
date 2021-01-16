# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class RefundOrOpenOrder
        include Interactor

        delegate :user, to: :context
        delegate :incident, to: :context
        delegate :order_action, to: :context

        def call
          return unless incident.dispute_opens_in_close_order?(user.profile)

          if order_action == 'refund'
            Cmd::Order::Refund.call(order: order,
                                    remaining_places: 1,
                                    cause: 'анкета из заявки переведена в спор.')
          else
            Cmd::Order::ToPublished.call(order: order)
          end
        end

        private

        def order
          @order ||= incident.proposal_employee.order
        end
      end
    end
  end
end
