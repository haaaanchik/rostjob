class ProductionSite < ApplicationRecord
  belongs_to :profile
  has_many :orders
  has_many :order_templates

  has_attached_file :image, styles: { thumb: '300x240' }, default_url: '/img/default_pp.png'
  validates_attachment_content_type :image, content_type: %w[image/jpeg image/gif image/png]

  validates :title, :city, :info, :phones, presence: true
end
