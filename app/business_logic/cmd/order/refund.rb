module Cmd
  module Order
    class Refund
      include Interactor

      def call
        amount = remaining_places * order.customer_price
        result = order.balance.deposit(amount, "Возврат денег из заявки №#{order.id}. Причина: заявка закрыта, количество оставшихся мест #{remaining_places}")
        context.fail!  if result.nil?
        order.decrement(:number_of_employees, remaining_places)
        context.fail! unless save_total_prices
      end

      private

      def order
        context.order
      end

      def remaining_places
        context.remaining_places
      end

      def save_total_prices
        order.customer_total = order.customer_price.to_i * order.number_of_employees.to_i
        order.contractor_total = order.contractor_price.to_i * order.number_of_employees.to_i
        order.save
      end
    end
  end
end
