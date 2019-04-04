module ProposalEmployeeRepository
  extend ActiveSupport::Concern

  included do
    scope :available, ->(profile_id) { where(state: %w[applyed], profile_id: profile_id) }
    scope :available_free, ->(profile_id, proposal_id) { available(profile_id).where(proposal_id: proposal_id) }
    scope :candidates, ->(profile_id) {
      where.not(state: 'revoked').joins(:order).joins(:employee_cv).where('orders.profile_id = ?', profile_id)
      .select('proposal_employees.*', 'orders.title, orders.place_of_work', 'employee_cvs.name')
    }
    scope :sort_by_employee_cv_name_asc, lambda { order('employee_cvs.name asc') }
    scope :sort_by_employee_cv_name_desc, lambda { order('employee_cvs.name desc') }
  end
end
