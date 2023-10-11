# frozen_string_literal: true

module Api
  module V1
    class Positions < Grape::API
      before { user_authenticated! }

      desc 'Create new positions',
           success: Entities::Position
      params do
        requires :title, type: String, desc: 'Title'
        requires :warranty_period, type: Integer, default: 10, desc: 'Warranty period (defaults to 10)'
        requires :landing_title, type: String, desc: 'Title to landing'
        optional :duties, type: String, desc: 'Duties'
        optional :description, type: String, desc: 'Description'
        requires :price_group_id, type: Integer, desc: 'Price group'
        requires :slug, type: String, desc: 'URL'
      end
      post '/positions' do
        position = Position.create(title: params[:title], warranty_period: params[:warranty_period],
                                   landing_title: params[:landing_title], duties: params[:duties],
                                   description: params[:description], price_group_id: params[:price_group_id],
                                   slug: params[:slug])

        present position, with: Entities::Position
      end
    end
  end
end
