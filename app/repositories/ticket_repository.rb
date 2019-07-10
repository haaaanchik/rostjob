module TicketRepository
  extend ActiveSupport::Concern

  included do
    scope :sort_by_employee_cv_name_asc, -> { order('employee_cvs.name asc') }
    scope :sort_by_employee_cv_name_desc, -> { order('employee_cvs.name desc') }
    scope :with_other_tickets_for, lambda { |user|
      if user.profile.contractor?
        where(user: user)
          .or(other_tickets_for_contractor(user.profile))
      elsif user.profile.customer?
        where(user: user)
          .or(other_tickets_for_customer(user.profile))
      end
    }
    scope :other_tickets_for_contractor, lambda { |profile|
      where(proposal_employee_id: profile.proposal_employees.pluck(:id))
    }

    scope :other_tickets_for_customer, lambda { |profile|
      where(proposal_employee_id: ProposalEmployee.candidates_ids_for(profile))
    }

    scope :with_last_complaint_time, lambda {
      joins(:complaints)
        .select('proposal_employees.*, max(complaints.created_at) as last_complaint_time')
        .group('proposal_employees.id')
        .order('last_complaint_time desc')
    }
  end
end
