module ProposalEmployeeRepository
  extend ActiveSupport::Concern

  included do
    scope :available, ->(profile_id) { where(state: %w[applyed], profile_id: profile_id) }
    scope :approved_by_admin, -> { where(approved_by_admin: false, state: 'paid') }
    scope :available_free, ->(profile_id, proposal_id) { available(profile_id).where(proposal_id: proposal_id) }
    scope :candidates, lambda { |profile_id|
      where.not(state: 'revoked').joins(:order).joins(:employee_cv).where('orders.profile_id = ?', profile_id)
        .select('proposal_employees.*', 'orders.place_of_work', 'orders.city', 'employee_cvs.name', 'employee_cvs.phone_number')
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
    scope :count_candidates_included_in_order, -> { where(state: ['hired', 'paid', 'approved']).count }
    scope :range_approved, -> (start_date, end_date){ where('warranty_date > ? AND warranty_date < ?', start_date, end_date)}
    scope :range_hiring, -> (start_date, end_date){ where('warranty_date > ? AND warranty_date < ?', start_date, end_date)}
    scope :range_interview, -> (start_date, end_date){ where('interview_date > ? AND interview_date < ?', start_date, end_date)}
    scope :range_inbox, -> (start_date, end_date){ where('interview_date > ? AND interview_date < ?', start_date, end_date)}
  end
end
