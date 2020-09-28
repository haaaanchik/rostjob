module Cmd
  module CrmColumns
    module EmployeeCv
      class Update
        include Interactor

        delegate :user, to: :context
        delegate :crm_column_id,  to: :context
        delegate :employee_cv_id, to: :context

        def call
          context.fail! if employee_cv.blank? || crm_column.blank?

          employee_cv.crm_columns_employee_cv.update(crm_column_id: crm_column_id)
        end

        private

        def employee_cv
          @employee_cv ||= user.profile.employee_cvs.find_by(id: employee_cv_id)
        end

        def crm_column
          user.crm_columns.find_by(id: crm_column_id)
        end
      end
    end
  end
end
