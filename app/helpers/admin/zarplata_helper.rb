module Admin::ZarplataHelper
  def zarplata_authorize_url
    zarplata_config = Rails.application.credentials[Rails.env.to_sym][:zarplata]
    query_params = {
      response_type: 'code',
      client_id: zarplata_config[:client_id],
      scope: 'basic'
    }
    "#{zarplata_config[:api_url]}/authorize?#{query_params.to_query}"
  end

  def payment_type_alias_option
    [
      ['Диапозон', 'range'],
      ['Оклад', 'fixed'],
      ['Оклад + процент', 'fixed_plus_bonus']]
  end
end




