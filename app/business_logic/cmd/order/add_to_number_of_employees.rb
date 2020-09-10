module Cmd
  module Order
    class AddToNumberOfEmployees
      include Interactor

      delegate :order,     to: :context
      delegate :dont_send, to: :context

      def call
        return if order.number_additional_employees.to_i.zero?

        summ_additional_employees = order.number_additional_employees * order.customer_price
        order.increment!(:number_of_employees, order.number_additional_employees)
        Cmd::UserActionLogger::Log.call(params: logger_params)
        customer_total = order.customer_price * order.number_of_employees
        contractor_total = order.contractor_price * order.number_of_employees
        order.update(number_additional_employees: nil,
                     customer_total:              customer_total,
                     contractor_total:            contractor_total)
        order.balance.withdraw(summ_additional_employees, "Увеличение количества сотрудников для заявки №#{order.id}")
        order.public_send(:to_open?) unless dont_send
      end

      private

      def current_user
        order.profile.user
      end

      def logger_params
        {
          login: current_user.email,
          receiver_ids: [current_user.id],
          subject_id: current_user.id,
          subject_type: 'User',
          subject_role: current_user.profile.profile_type,
          action: "Добавлен(о) #{order.number_additional_employees} сотрудник(ов) к заявке №#{order.id} #{order.title}",
          object_id: order.id,
          object_type: 'Order',
          order_id: order.id
        }
      end
    end
  end
end
