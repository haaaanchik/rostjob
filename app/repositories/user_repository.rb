module UserRepository
  extend ActiveSupport::Concern

  included do
    scope :clients, -> {
      select(:id, :email, :profile_id, :full_name, :amount, :employee_cvs_count, :orders_count, :last_sign_in_at)
          .joins(:balance)
          .joins('left join (select profile_id, count(profile_id) as employee_cvs_count from employee_cvs group by profile_id) e on profiles.id = e.profile_id')
          .joins('left join (select profile_id, count(profile_id) as orders_count from orders group by profile_id) o on profiles.id = o.profile_id')
    }
    scope :customers, -> { clients.where('profiles.profile_type = ?', 'customer') }
    scope :contractors, -> { clients.where('profiles.profile_type = ?', 'contractor') }
    scope :sort_by_amount_asc, -> { order('amount asc') }
    scope :sort_by_amount_desc, -> { order('amount desc') }
    scope :sort_by_orders_count_asc, -> { order('orders_count asc') }
    scope :sort_by_orders_count_desc, -> { order('orders_count desc') }
    scope :sort_by_employee_cvs_count_asc, -> { order('employee_cvs_count asc') }
    scope :sort_by_employee_cvs_count_desc, -> { order('employee_cvs_count desc') }
  end
end