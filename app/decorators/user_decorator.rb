class UserDecorator < ApplicationDecorator
  delegate_all

  def disputs_count
    0
  end

  def label_full_name
    profile.contractor? ? 'Фамилия Имя' : 'Наименование организации'
  end

  def withdrawal_link
    return if !(profile.contractor? && balance.amount > 0.0)

    h.content_tag(:a,
                  href: h.withdrawal_admin_user_path(object.id),
                  class: 'blue-text',
                  data: { method: :put, remote: true, disable_with: false }) { 'Выписать счет' }
  end

  def count_orders_or_employees
    return orders_count if user.profile.customer?

    employee_cvs_count
  end

  private

  def orders_count
    model.orders_count ? model.orders_count : 0
  end

  def employee_cvs_count
    model.employee_cvs_count ? model.employee_cvs_count : 0
  end
end
