module OrderRepository
  extend ActiveSupport::Concern

  included do
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
      select('orders.*, proposal_employees.employee_cv_id as employee_cv_id, employee_cvs.name as employee_cv_name')
        .where('proposal_employees.state = ?', 'deleted')
        .joins('left join employee_cvs on proposal_employees.employee_cv_id = employee_cvs.id')
    }

    scope :filter_by_day, -> {where 'created_at >= ?', Date.current - 1.day}
    scope :filter_by_3day, -> {where 'created_at >= ?', Date.current - 3.days}
    scope :filter_by_week, -> {where 'created_at >= ?', Date.current - 1.week}
    scope :filter_by_all_time, -> {all}
    scope :sort_by_reward_asc, -> {order commission: :asc}
    scope :sort_by_reward_desc, -> {order commission: :desc}
    scope :sort_by_date_asc, -> {order created_at: :asc}
    scope :sort_by_date_desc, -> {order created_at: :desc}
    scope :by_query, ->(term) {where('title LIKE ? OR description LIKE ?', "%#{term}%", "%#{term}%")}
  end
end
