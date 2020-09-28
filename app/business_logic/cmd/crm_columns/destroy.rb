module Cmd
  module CrmColumns
    class Destroy
      include Interactor

      delegate :user, to: :context
      delegate :column_id, to: :context

      def call
        context.fail! if column.blank? || column.employee_cvs.any?

        column.destroy
      end

      def column
        @column ||= user.crm_columns.find_by(id: column_id)
      end
    end
  end
end
