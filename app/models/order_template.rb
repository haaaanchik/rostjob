# frozen_string_literal: true

class OrderTemplate < ApplicationRecord
  include Order::OrderTemplatable
  extend Enumerize

  belongs_to :profile
  belongs_to :production_site
  belongs_to :position
  has_one :user, through: :profile
  belongs_to :city, class_name: 'Geo::City', optional: true

  enumerize :urgency, in: %i[low middle high], scope: true, default: :middle
  enumerize :urgency_level, in: { low: 0, middle: 1, high: 2 }, scope: true

  validates :customer_price, :contractor_price, :customer_total, :contractor_total,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true

  has_attached_file :document
  validates_attachment_content_type :document, content_type: /.*\/.*\z/

  scope :by_query, ->(term) { where('name LIKE ? OR title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%") }

  ransack_alias :order_template_fields, :name_or_title_or_description_or_city_or_specialization_or_skill_or_district_or_place_of_work_or_salary

  def initialize(attrs = nil)
    defaults = default_init

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

  def title
    position&.title
  end
end
