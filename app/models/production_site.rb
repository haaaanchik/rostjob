class ProductionSite < ApplicationRecord
  belongs_to :profile
  has_many :orders
  has_many :order_templates
  has_many :proposal_employees, through: :orders

  has_attached_file :image, styles: { thumb: '300x240' }, default_url: '/img/default_pp.png'
  validates_attachment_content_type :image, content_type: %w[image/jpeg image/gif image/png]

  validates :title, :city, :info, :phones, presence: true

  def number_free_places
    orders.where(state: ['published', 'completed']).sum(:number_of_employees) - count_only_included_candidate
  end

  def inbox_candidate_count
    proposal_employees.inbox.count
  end

  def count_only_included_candidate
    proposal_employees.count_candidates_included_in_order
  end
end
