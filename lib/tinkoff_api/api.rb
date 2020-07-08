module TinkoffApi::Api
  BASE_URL = 'https://business.tinkoff.ru/openapi/api/v1/'

  def invoicing(query, body_params)
    response = RestClient.post(BASE_URL + query, body_params.to_json, header)
    json_parse(response)
  rescue => e
    { error: error_message(e) }
  end

  def statement_invoices(query)
    response = RestClient.get(BASE_URL + query, header)
    json_parse(response)
  rescue => e
    { error: error_message(e) }
  end

  private

  def header
    app_env = Rails.env.to_sym
    token = Rails.application.credentials[app_env][:tinkoff][:token]
    { Authorization: 'Bearer ' + token }
  end

  def error_message(error)
    response = error.response.body
    case error.response.code
    when 400
      parse_error = json_parse(response)
      if response['errorDetails'].present?
        response = parse_error['errorDetails'].first[1]
      else
        response = parse_error['errorMessage']
      end
    when 422, 500
      response = json_parse(response)['errorMessage']
    else
      response
    end
    Rails.logger.debug "TinkoffApi error! #{response}"
    response
  end

  def json_parse(response)
    JSON.parse(response)
  end
end