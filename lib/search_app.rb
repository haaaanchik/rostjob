class SearchApp
  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    params = @request.params

    auto_list = case env['PATH_INFO']
                when '/search_city'
                  CityReference.autocomplete_search(params['term'])
                when '/search_specialization'
                  SpecializationReference.autocomplete_search(params['term'])
                else
                  ''
                end

    auto_list == '' ? @app.call(env) :
      [200, {'Content-Type' => 'application/json'}, [auto_list.to_json]]
  end
end
