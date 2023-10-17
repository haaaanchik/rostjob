# frozen_string_literal: true

module Api
  module V1
    class Specializations < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'List of specializations',
           is_array: true,
           success: Entities::Specialization
      params do
        optional :search, type: String, desc: 'Search by title'
        use :pagination_filters
      end
      get '/specializations' do
        q = Specialization.ransack(title_cont: params[:search])
        specializations = q.result.page(params[:page]).per(params[:per])

        present :specializations, specializations, with: Entities::Specialization
        present :page, specializations.current_page
        present :total_pages, specializations.total_pages
      end


      desc 'Show specialization',
           success: Entities::Specialization
      params do
        requires :id, type: Integer, desc: 'Specialization ID'
      end
      get '/specializations/:id' do
        present Specialization.find(params[:id]), with: Entities::Specialization
      end


      desc 'Create new specializations',
           success: Entities::Specialization
      params do
        requires :title, type: String, desc: 'Title'
        # optional :image, type: Rack::Multipart::UploadedFile, desc: 'Upload in image/jpeg image/gif image/png format'
      end
      post '/specializations' do
        specialization = Specialization.create(title: params[:title])

        present specialization, with: Entities::Specialization
      end


      desc 'Update specialization details',
           success: Entities::Specialization
      params do
        requires :id, type: Integer, desc: 'Specialization ID'
        optional :title, type: String, desc: 'Title'
      end
      put '/specializations/:id' do
        specialization = Specialization.find(params[:id])
        specialization.update(params.slice('title'))

        present specialization, with: Entities::Specialization
      end

      desc 'List of positions by specialization',
           is_array: true,
           success: Entities::Position
      params do
        requires :specialization_id, type: Integer, desc: 'Specialization ID'
      end
      get '/specializations/:specialization_id/positions' do
        specialization = Specialization.find(params[:specialization_id])
        positions = specialization.positions.page(params[:page]).per(params[:per])

        present :positions, positions, with: Entities::Position
        present :page, positions.current_page
        present :total_pages, positions.total_pages
      end
    end
  end
end
