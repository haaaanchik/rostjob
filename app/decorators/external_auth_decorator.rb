class ExternalAuthDecorator < ApplicationDecorator
  def display_zp_status
    return not_zp_authorized if values.blank?
    return zp_authorized if values && Time.current < (updated_at + values['expires_in'].seconds)

    zp_refresh_token
  end

  private

  def not_zp_authorized
    h.content_tag(:h5, 'Статус: авторизация не пройдена')
      .concat(h.link_to 'Авторизоваться',
                        h.zarplata_authorize_url,
                        class: 'btn btn-success')
  end

  def zp_authorized
    h.content_tag(:h5, 'Статус: авторизация пройдена')
      .concat(h.content_tag(:h5, "Токен действителен до: #{l(updated_at + values['expires_in'].seconds,
                                                             format: :long)}"))
  end

  def zp_refresh_token
    h.content_tag(:h5, 'Статус: срок действия токена истекло')
      .concat(h.link_to 'Обновить',
                        h.admin_zarplata_refresh_token_path,
                        class: 'btn btn-primary')
  end
end
