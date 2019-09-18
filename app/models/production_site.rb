class ProductionSite < ApplicationRecord
  belongs_to :profile
  has_many :orders
  has_many :order_templates

  validates :title, presence: true
end
