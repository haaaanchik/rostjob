# frozen_string_literal: true

module Api
  module V1
    class Specializations < Grape::API

      desc 'Specializations and profession' do
        is_array true
        success Entities::Specialization
      end

      get '/specializations' do
        specializations = ActiveSpecializationsSpecification.to_scope

        present specializations, with: Entities::Specialization, host: request.host_with_port
      end
    end
  end
end
