class CrmColumnsEmployeeCv < ApplicationRecord
  belongs_to :crm_column
  belongs_to :employee_cv

  validates :employee_cv_id, uniqueness: { scope: :crm_column_id }
end
