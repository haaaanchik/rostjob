module SuperJobApi
  class Client
    def initialize(config, query = nil)
      @api_url = Rails.configuration.superjob['api_url']
      @client_id = config['client_id']
      @base_headers = {
        'Authorization' => "Bearer #{config['access_token']}",
        'X-Api-App-Id' => Rails.configuration.superjob['client_secret']
      }
      qp = query ? query['query_params'] : config.active_query['query_params']
      @query_params = qp
    end

    def references
      endpoint = 'references'
      get(endpoint)
    end

    def catalogues
      endpoint = 'catalogues'
      get(endpoint)
    end

    def regions_combined
      endpoint = 'regions/combined'
      get(endpoint)
    end

    def regions
      endpoint = 'regions'
      get(endpoint, all: 1)
    end

    def towns
      endpoint = 'towns'
      get(endpoint, all: 1, id_country: 1)
    end

    def all_resumes_with_contacts
      resume_ids = all_resumes.map { |res| res['id'] }
      resumes = resume_ids.map do |resume_id|
        sleep(0.4)
        resume_with_contacts(resume_id)
      end
      res = resumes.reject(&:nil?).map do |resume|
        res = resume['resume']
        {
          resume_id: res['id'],
          link: res['link'],
          phone: res['phone1'] || res['phone2'],
          gender: res['gender']['id'] == 2 ? 'М' : 'Ж',
          email: res['email']
        }
      end
      res.select { |r| r[:phone].present? }
    end

    def resume_with_contacts(resume_id)
      endpoint = "hr/resumes/#{resume_id}/open"
      get(endpoint)
    end

    def resume(resume_id)
      endpoint = "resumes/#{resume_id}"
      get(endpoint)
    end

    def all_resumes
      resumes = []
      page = 0
      endpoint = 'resumes'
      response = get(endpoint, @query_params.merge(count: 100, page: page))
      if response
        resumes += response['objects']

        while response['more'] && page < 20
          page += 1
          response = get(endpoint, @query_params.merge(count: 100, page: page))
          resumes += response['objects'] if response
        end
      end
      resumes
    end

    def resumes
      endpoint = 'resumes'
      get(endpoint, @query_params.merge(count: 100))
    end

    private

    def get(endpoint, query_params = {}, custom_headers = {})
      uri = "#{@api_url}/#{endpoint}"
      headers = @base_headers.merge(custom_headers)
      params = query_params.present? ? { params: query_params } : {}
      result = RestClient.get(uri, params.merge(headers))
      JSON.parse(result)
    rescue => e
      # JSON.parse(e.response)
      nil
    end
  end
end
