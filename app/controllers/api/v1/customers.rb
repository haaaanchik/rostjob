# frozen_string_literal: true

module Api
  module V1
    class Customers < Grape::API

      desc 'Get a free manager'
      get '/free_manager' do
        result = Cmd::FreeManager::Sample.call

        { status: 200, data: result.manager || [] }
      end
    end
  end
end
