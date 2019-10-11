module ProposalEmployeeRepository
  extend ActiveSupport::Concern

  included do
    scope :available, ->(profile_id) { where(state: %w[applyed], profile_id: profile_id) }
    scope :available_free, ->(profile_id, proposal_id) { available(profile_id).where(proposal_id: proposal_id) }
    scope :candidates, lambda { |profile_id|
      where.not(state: 'revoked').joins(:order).joins(:employee_cv).where('orders.profile_id = ?', profile_id)
        .select('proposal_employees.*', 'orders.title, orders.place_of_work', 'orders.city', 'employee_cvs.name', 'employee_cvs.phone_number')
    }
    scope :candidates_ids_for, lambda { |profile_id|
      joins(:order).where('orders.profile_id = ?', profile_id).pluck(:id)
    }
    scope :sort_by_employee_cv_name_asc, -> { order('employee_cvs.name asc') }
    scope :sort_by_employee_cv_name_desc, -> { order('employee_cvs.name desc') }
    scope :with_last_complaint_time, lambda {
      joins(:complaints)
        .select('proposal_employees.*, max(complaints.created_at) as last_complaint_time')
        .group('proposal_employees.id')
        .order('last_complaint_time desc')
    }
    scope :paid_employees_during, ->(profile_id, current_date, prev_date) { where('proposal_employees.state = ? and
                                                                                   proposal_employees.profile_id = ? and
                                                                                   proposal_employees.payment_date < ? and
                                                                                   proposal_employees.payment_date > ? ',
                                                                                  'paid', profile_id, current_date, prev_date) }
  end
end
