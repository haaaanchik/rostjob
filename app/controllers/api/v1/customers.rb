# frozen_string_literal: true

module Api
  module V1
    class Customers < Grape::API

      desc 'All logos' do
        is_array true
        success Entities::Profiles::Logo
      end

      get '/customers/logos' do
        customer_logos = Profile.customers.where.not(photo_file_name: nil)

        present customer_logos,  with: Entities::Profiles::Logo, base_url: request.base_url
      end
    end
  end
end
