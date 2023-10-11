# frozen_string_literal: true

module Api
  module V1
    class Specializations < Grape::API
      before { user_authenticated! }

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
    end
  end
end
