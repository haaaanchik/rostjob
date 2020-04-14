class UserDecorator < ApplicationDecorator
  delegate_all

  def orders_count
    model.orders_count ? model.orders_count : 0
  end

  def employee_cvs_count
    model.employee_cvs_count ? model.employee_cvs_count : 0
  end

  def disputs_count
    0
  end

  def label_full_name
    profile.contractor? ? 'Фамилия Имя' : 'Наименование организации'
  end

  def withdrawal_link
    return tag_td if object.profile_type == 'customer'
    object.amount <= 0.0 ? tag_td : tag_td_a
  end

  private

  def tag_td
    h.content_tag(:td) {}
  end

  def tag_td_a
    h.content_tag(:td, data: { 'user-id': object.id }) do
      h.content_tag(:a,
                    href: h.withdrawal_admin_client_path(object.id),
                    class: 'blue-text',
                    data: { method: :put, remote: true }) { 'выписать счет' }
    end
  end
end
