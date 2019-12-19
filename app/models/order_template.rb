class OrderTemplate < ApplicationRecord
  extend Enumerize

  belongs_to :profile
  belongs_to :production_site
  belongs_to :position

  enumerize :urgency, in: %i[low middle high], scope: true, default: :middle
  enumerize :urgency_level, in: { low: 0, middle: 1, high: 2 }, scope: true

  attr_accessor :template_creation_step

  validates :customer_price, :contractor_price, :customer_total, :contractor_total,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :city, :salary, presence: true, if: -> { template_creation_step == 2 }
  validates :name, :title, :production_site_id, presence: true, if: -> { template_creation_step == 1 }

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /.*\/.*\z/

  scope :by_query, ->(term) { where('name LIKE ? OR title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%") }

  ransack_alias :order_template_fields, :name_or_title_or_description_or_city_or_specialization_or_skill_or_district_or_place_of_work_or_salary

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
        terms: "<b>Обязанности:</b>\n<ul>\n<li></li>\n<li></li>\n</ul>\n<strong>Требования:</strong>\n
<ul>\n<li></li>\n<li></li>\n</ul>\n<strong>Условия:</strong>\n<ul>\n<li></li><li></li>\n</ul>",
        related_profession: nil
      },
      contact_person: {
        name: nil,
        phone: nil
      },
      urgency_level: :middle,
      for_cis: false,
      advertising: false,
      adv_text: nil
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end
end
