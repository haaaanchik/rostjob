module DadataApi
  DEF_URL = 'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/'.freeze
  TOKEN = 'f13b5b35ffbd8dc4f5f7421a3a7fc34a96697a44'.freeze

  def self.post_dadata(url, data)
    require 'uri'
    require 'net/http'

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.set_debug_output $stderr if ENV['RAILS_ENV'] == 'development'

    request = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/json'
    request['accept'] = 'application/json'
    request['authorization'] = "Token #{TOKEN}"
    request['cache-control'] = 'no-cache'
    request.body = data.to_json

    response = http.request(request)
    decode = JSON.parse(response.read_body, object_class: OpenStruct)
    decode.suggestions
  end

  def self.get_party(params)
    url = URI("#{DEF_URL}party?")
    data = { query: params, count: 10 }
    post_dadata(url, data)
  end

  def self.get_addr(params)
    url = URI("#{DEF_URL}address?")
    # Если нужно ограничение по региону
    # loc = [{region: 'Татарстан'}]
    # data = {query: params, locations: loc}
    data = { query: params, count: 20 }
    post_dadata(url, data)
  end

  def self.get_bank(params)
    url = URI("#{DEF_URL}bank?")
    data = { query: params, count: 10 }
    post_dadata(url, data)
  end

  def self.get_ifns(params)
    url = URI("#{DEF_URL}fns_unit")
    data = { query: params, count: 10 }
    post_dadata(url, data)
  end
end
