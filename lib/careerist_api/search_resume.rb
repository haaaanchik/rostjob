class CareeristApi::SearchResume
  BASE_URL = 'http://careerist.ru/scr/api/search-resume'

  def post_request(query_params)
    login = Rails.application.credentials.careerist[:login]
    login_key = Rails.application.credentials.careerist[:login_key]
    body = query_params.merge(Login: login, LoginKey: login_key)
    request = RestClient.post(BASE_URL, body)
    JSON.parse(request)
  rescue => e
    Rails.logger.debug "Careerist search resume error! #{e}"
  end
end