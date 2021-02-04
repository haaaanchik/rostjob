# frozen_string_literal: true

module Api
  module V1
    class Specializations < Grape::API

      desc 'Specializations and profession' do
        is_array true
        success Entities::Specialization
      end
      params do
        optional :page,  type: Integer, default: 1, desc: 'Specify the page of paginated results.'
        optional :city_eq, type: String, desc: 'Order city.'
        optional :title_fields_in, type: Array, desc: 'Order title.'
        optional :title_or_company_fields_cont, type: String, desc: 'Search by order title or company name.'
      end

      get '/specializations' do
        specializations = ActiveSpecializationsSpecification.to_scope

        present specializations, with: Entities::Specialization
      end
    end
  end
end
