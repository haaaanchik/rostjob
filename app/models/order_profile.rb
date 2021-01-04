class OrderProfile < ApplicationRecord
  belongs_to :order
  belongs_to :profile

  scope :count_candidate_without, -> (hash_values = {}) do
                                                      joins(:order)
                                                      .joins('LEFT JOIN proposal_employees ON proposal_employees.order_id = order_profiles.order_id')
                                                      .where(profile_id: hash_values[:profile].id )
                                                      .where(proposal_employees: { profile_id: hash_values[:profile].id })
                                                      .where.not(proposal_employees: { state: [:revoked, hash_values[:state]] })
                                                      .group('order_profiles.order_id').count
  end
end
