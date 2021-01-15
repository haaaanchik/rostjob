# frozen_string_literal: true

module Api
  module V1
    class Contractors < Grape::API

      desc 'Get a free manager'
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
    end
  end
end
