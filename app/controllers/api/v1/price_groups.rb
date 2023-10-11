# frozen_string_literal: true

module Api
  module V1
    class PriceGroups < Grape::API
      before { user_authenticated! }

      desc 'Create new price group',
           success: Entities::PriceGroup
      params do
        requires :title, type: String, desc: 'Title'
        requires :customer_price, type: Integer, desc: 'Customer price'
        requires :contractor_price, type: Integer, desc: 'Contractor price'
      end
      post '/price_groups' do
        price_group = PriceGroup.create(title: params[:title],
                                        customer_price: params[:customer_price],
                                        contractor_price: params[:contractor_price])

        present price_group, with: Entities::PriceGroup
      end
    end
  end
end
