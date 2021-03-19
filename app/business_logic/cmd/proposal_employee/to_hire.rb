# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    class ToHire
      include Interactor

      delegate :candidate, to: :context

      def call
        context.fail!(errors: error_message) if context.hiring_date.blank? || order.number_free_places < 1

        candidate.update(hiring_date: hiring_date,
                         warranty_date: Holiday.warranty_date(hiring_date, order.warranty_period))

        context.fail!(errors: 'Не удалось нанять кандидата') unless candidate.hire!
      end

      private

      def order
        candidate.order
      end

      def hiring_date
        Date.parse(context.hiring_date)
      end

      def error_message
        if context.hiring_date.blank?
          'Пустое значение даты нанятия'
        else
          'Заявка уже закрыта'
        end
      end
    end
  end
end
