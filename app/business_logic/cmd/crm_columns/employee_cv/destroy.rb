module Cmd
  module CrmColumns
    module EmployeeCv
      class Destroy
        include Interactor

        delegate :employee_cv_id, to: :context
        delegate :current_profile, to: :context

        def call
          context.fail! if employee_cv.blank?

          employee_cv.crm_columns_employee_cv.destroy
        end

        private

        def employee_cv
          @employee_cv ||= current_profile.employee_cvs.find_by(id: employee_cv_id)
        end
      end
    end
  end
end
