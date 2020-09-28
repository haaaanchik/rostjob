class CrmColumn < ApplicationRecord
  belongs_to :user

  has_many :crm_columns_employee_cvs, dependent: :destroy
  has_many :employee_cvs, through: :crm_columns_employee_cvs
end
