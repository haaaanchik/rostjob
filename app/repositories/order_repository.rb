module OrderRepository
  extend ActiveSupport::Concern

  included do
    scope :with_customer_name, -> {
      select('orders.*, profiles.id as p_id, companies.name as customer_name')
        .joins('inner join profiles on orders.profile_id = profiles.id')
        .joins('inner join companies on (companies.companyable_id = profiles.id and companies.companyable_type = "Profile")')
    }

    scope :with_pe_counts, -> {
      select('orders.*, total_pe_count, unviewed_pe_count')
        .joins('left join (select order_id, count(*) as total_pe_count from proposal_employees group by order_id) tpe on tpe.order_id = orders.id')
        .joins('left join (select order_id, count(*) as unviewed_pe_count from proposal_employees where marks ->"$.viewed_by_customer" = false group by order_id) upe on upe.order_id = orders.id')
    }

    scope :with_unviewed_pe_count, -> {
      select('orders.*, unviewed_pe_count')
        .joins('join (select order_id, count(*) as unviewed_pe_count from proposal_employees where state = "inbox" group by order_id) upe on upe.order_id = orders.id')
    }

    scope :with_disputed_employee_cvs, -> {
      select('orders.*, proposal_employees.id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .joins(:proposal_employees)
        .where('proposal_employees.state = ?', 'disputed')
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :with_disputed_employee_cvs_contractor, -> {
      select('orders.*, proposal_employees.id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .where('proposal_employees.state = ?', 'disputed')
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :with_deleted_employee_cvs_contractor, -> {
      select('orders.*, proposal_employees.id as pe_id, employee_cvs.name as employee_cv_name')
        .where('proposal_employees.state = ?', 'deleted')
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :candidates, -> {
      select('orders.*, proposal_employees.id as pe_id, proposal_employees.state as pe_state, proposal_employees.updated_at as pe_updated_at, employee_cvs.id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .joins('join proposal_employees on proposal_employees.order_id = orders.id')
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :with_hired_candidates, -> {
      select('orders.*, proposal_employees.id as pe_id, proposal_employees.state as pe_state, proposal_employees.updated_at as pe_updated_at, employee_cvs.id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .joins('join proposal_employees on proposal_employees.order_id = orders.id')
        .where('proposal_employees.state = ? and proposal_employees.hiring_date <= ? and proposal_employees.hiring_date_corrected is ?', 'hired', Date.current, nil)
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :with_interviewed_candidates, -> {
      select('orders.*, proposal_employees.id as pe_id, proposal_employees.state as pe_state, proposal_employees.updated_at as pe_updated_at, proposal_employees.interview_date as interview_date, employee_cvs.id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .joins('join proposal_employees on proposal_employees.order_id = orders.id')
        .where('proposal_employees.state = ? and proposal_employees.interview_date <= ? and proposal_employees.hiring_date_corrected is ?', 'interview', Date.current, nil)
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    # scope :candidates, -> {
    #   select('orders.*, proposal_employees.state as pe_state')
    #     .joins(:proposal_employees)
    #   # joins('inner join proposal_employees on proposal_employees.order_id = orders.id')
    #   # .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    # }
    scope :filter_by_day, -> {where 'created_at >= ?', Date.current - 1.day}
    scope :filter_by_3day, -> {where 'created_at >= ?', Date.current - 3.days}
    scope :filter_by_week, -> {where 'created_at >= ?', Date.current - 1.week}
    scope :filter_by_all_time, -> {all}
    scope :sort_by_reward_asc, -> {order commission: :asc}
    scope :sort_by_reward_desc, -> {order commission: :desc}
    scope :sort_by_date_asc, -> {order created_at: :asc}
    scope :sort_by_date_desc, -> { order(urgency_level: :desc, created_at: :desc) }
    scope :by_query, ->(term) {where('id like ? or title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")}
    scope :sort_by_order_title_asc, lambda { order('orders.title asc') }
    scope :sort_by_order_title_desc, lambda { order('orders.title desc') }
    scope :sort_by_order_place_of_work_asc, lambda { order('orders.place_of_work asc') }
    scope :sort_by_order_place_of_work_desc, lambda { order('orders.place_of_work desc') }
    scope :sort_by_customer_name_asc, -> { order('companies.name asc') }
    scope :sort_by_customer_name_desc, -> { order('companies.name desc') }
  end
end
