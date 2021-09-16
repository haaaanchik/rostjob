# frozen_string_literal: true

class SearchApp
  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    params = @request.params

    auto_list = case env['PATH_INFO']
                when '/search_geo_city'
                  Geo::City.autocomplete_search(params['term'])
                when '/search_specialization'
                  Specialization.autocomplete_search(params['term'])
                when '/search_admin_position'
                  SearchPositionQuery.call(term: params['q']).limit(20)
                when '/search_position'
                  Position.autocomplete_search(params['term'])
                when '/search_company_dadata'
                  Company.search_company_dadata(params['term'])
                when '/search_bank_dadata'
                  Account.search_bank_dadata(params['term'])
                when '/search_ifns'
                  Company.search_ifns_dadata(params['term'])
                when '/search_zarplata_rubrics'
                  ZarplataRu::Search.rubrics
                when '/search_zarplata_specialties'
                  ZarplataRu::Search.specialties(params['parent_id'])
                when '/search_zarplata_city'
                  ZarplataRu::Search.city(params['term'])
                else
                  ''
                end

    if auto_list == ''
      @app.call(env)
    else
      [200, { 'Content-Type' => 'application/json' }, [auto_list.to_json]]
    end
  end
end
