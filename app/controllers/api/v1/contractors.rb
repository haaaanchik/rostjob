# frozen_string_literal: true

module Api
  module V1
    class Contractors < Grape::API

      desc 'Call candidate modal show'
      params do
        requires :guid,  type: String, desc: 'Contractor guid'
        requires :name,  type: String, desc: 'Candidate name'
        requires :phone, type: String, desc: 'Candidates phone number'
      end
      get '/candidates' do
        result = Cmd::Api::BotCallback::Process.call(guid: params[:guid],
                                                     name: params[:name],
                                                     phone: params[:phone])

        raise Errors.new(text: result.message,
                         code: result.code,
                         status: 422) if result.failure?

        { status: :ok }
      end


      desc 'Get a free manager'
      get '/free_manager' do
        result = Cmd::FreeManager::Sample.call

        { status: 200, data: result.manager || [] }
      end
    end
  end
end
