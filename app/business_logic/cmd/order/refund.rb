# frozen_string_literal: true

module Cmd
  module Order
    class Refund
      include Interactor

      delegate :cause, to: :context
      delegate :order, to: :context
      delegate :remaining_places, to: :context

      def call
        amount = remaining_places * order.customer_price
        result = order.balance.deposit(amount, "Возврат денег из заявки №#{order.id}. Причина: #{cause}")
        context.fail! if result.blank?
        order.decrement(:number_of_employees, remaining_places)
        context.fail! unless save_total_prices
      end

      private

      def save_total_prices
        order.customer_total = order.customer_price.to_i * order.number_of_employees.to_i
        order.contractor_total = order.contractor_price.to_i * order.number_of_employees.to_i
        order.save
      end
    end
  end
end
