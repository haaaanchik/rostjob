# frozen_string_literal: true

class ProductionSite < ApplicationRecord
  belongs_to :profile
  has_many :orders, dependent: :destroy
  has_many :order_templates, dependent: :destroy
  has_many :proposal_employees, through: :orders
  has_one :user, through: :profile

  has_attached_file :image, styles: { thumb: '300x240' }, default_url: '/img/default_pp.png'
  validates_attachment_content_type :image, content_type: %w[image/jpeg image/gif image/png]

  validates :title, :city, :info, :phones, presence: true

  def number_free_places
    orders.where(state: %w[published completed]).sum(:number_of_employees) - proposal_employees.count_candidates_included_in_order
  end

  def inbox_candidate_count
    proposal_employees.inbox.count
  end

  def order_dispute_count
    proposal_employees.disputed.count
  end

  def order_candidates_in_hire
    proposal_employees.count_candidates_in_hire
  end

end
