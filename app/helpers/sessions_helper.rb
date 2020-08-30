module SessionsHelper

  def set_cookies_params(user)
    cookies[:profile_type] = user.profile.profile_type
    cookies[:terms_of_service] = user.terms_of_service
    cookies[:updated_by_self_at] = user.profile.updated_by_self_at
    cookies[:password_changed_at] = user.password_changed_at
    cookies[:first_order_template_created] = user.first_order_template_created
  end

  def delete_cookies_params
    cookies.delete(:profile_type)
    cookies.delete(:terms_of_service)
    cookies.delete(:updated_by_self_at)
    cookies.delete(:password_changed_at)
    cookies.delete(:first_order_template_created)
  end
end
