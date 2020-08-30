module ZarplataRu
  module Base
    def get_access_token(url, body_params)
      response = RestClient.post(url, body_params)
      json_parse(response)
    rescue => e
      { error: error_message(e) }
    end

    def get_search(url)
      response = RestClient.get(url, header)
      json_parse(response)
    rescue => e
      { error: error_message(e) }
    end

    private

    def header
      { Authorization: "token #{external_auth_zarplata.values['access_token']}" }
    end

    def external_auth_zarplata
      @zarplata ||= ExternalAuth.zarplata
    end

    def zarplata_config
      @zarplata_config || Rails.application.credentials[Rails.env.to_sym][:zarplata]
    end

    def error_message(error)
      response = json_parse(error.response.body)
      Rails.logger.debug "ZarplataRu Api error! #{response}"
      response['errors'][0]['message']
    end

    def json_parse(response)
      JSON.parse(response)
    end

    def uri_encode(term)
      URI.encode(term)
    end
  end
end
