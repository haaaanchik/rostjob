# frozen_string_literal: true

module Cmd
  module CrmColumns
    module EmployeeCv
      class Create
        include Interactor

        delegate :user, to: :context
        delegate :crm_column_id, to: :context
        delegate :employee_cv_id, to: :context

        def call
          context.fail! if employee_cv.blank? || crm_column.blank?

          association = CrmColumnsEmployeeCv.find_or_initialize_by(employee_cv_id: employee_cv_id)
          association.crm_column_id = crm_column_id
          association.save
        end

        private

        def employee_cv
          @employee_cv ||= user.profile.employee_cvs.find_by(id: employee_cv_id)
        end

        def crm_column
          @crm_column ||= user.crm_columns.find_by(id: crm_column_id)
        end
      end
    end
  end
end
