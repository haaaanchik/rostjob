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
      get '/candidates/new' do
        result = Cmd::Api::BotCallback::Process.call(guid: params[:guid],
                                                     name: params[:name],
                                                     phone: params[:phone])
        if result.failure?
          raise Errors.new(text: result.message,
                           code: result.code,
                           status: 422)
        end

        { status: :ok }
      end


      desc 'Get a free manager'
      get '/free_manager' do
        result = Cmd::FreeManager::Sample.call

        { status: 200, data: result.manager }
      end


      desc 'Checking slug on valid'
      get '/contractors/checking_slug/:slug' do
        user = User.find_by(slug: params[:slug])

        if user.blank? || user.customer?
          raise Errors.new(text: 'Slug invalid',
                           code: 403,
                           status: 404)
        end

        { status: 200, phone: user.profile.phone }
      end
    end
  end
end
