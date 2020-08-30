module ZarplataRu::Vacancy
  class << self
    include ZarplataRu::Base

    def publish(params)
      @params = params

      post_vacancy
    end

    private

    def post_vacancy
      response = RestClient.post(zarplata_config[:api_url] + '/vacancies',
                                 body_params.to_json, header)
      json_parse(response)
    rescue => e
      { error: error_message(e) }
    end

    def body_params
      @params[:rubrics] = [{ id: @params[:rubrics][:id],
                           specialities: @params[:rubrics][:specialities].map{ |spec| { id: spec } } }]
      @params[:contact][:email] = 'manager@rostjob.com'
      @params[:contact][:phones] = [{ phone: @params[:contact][:phones] }]
      @params[:contact][:city] = { id: @params[:contact][:city].to_i }
      @params
    end

    def header
      { Authorization: "token #{external_auth_zarplata.values['access_token']}" }
    end

    def error_message(error)
      response = json_parse(error.response.body)
      Rails.logger.debug "ZarplataRu Api error! #{response}"

      case error.response.code
      when 401
        'Пожалуйста авторизуйтесь еще раз на zarplata.ru'
      when 429
        'Превышено максимальное количество запросов. Отправляйте меньше запросов!'
      else
        response['errors'][0]['message']
      end
    end
  end
end