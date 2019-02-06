class OrderTemplate < ApplicationRecord
  belongs_to :profile

  validates :name, :customer_price, :contractor_price, :customer_total, :contractor_total,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :number_of_employees, presence: true, numericality: { only_integer: true }
  validates :title, :city, :experience, :description,
            :schedule, :work_period, presence: true
  validates :salary_from, presence: true, numericality: { only_integer: true }
  validates :salary_to, presence: true, numericality: { only_integer: true }
  validates :warranty_period, presence: true, numericality: { only_integer: true }
  validates :accepted, acceptance: { message: 'must be abided' }

  def initialize(attrs = nil)
    defaults = {
      name: "Шаблон заявки от #{Time.current.strftime('%d-%m-%Y %T')}",
      base_customer_price: 0,
      base_contractor_price: 0,
      customer_price: 0,
      contractor_price: 0,
      customer_total: 0,
      contractor_total: 0,
      warranty_period: 10,
      number_of_employees: 1,
      other_info: {
        age_from: nil,
        age_to: nil,
        remark: nil,
        sex: nil,
        terms: nil,
        related_profession: nil
      }
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end
end
