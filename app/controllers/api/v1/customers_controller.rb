# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApiV1Controller

      def index
        customers = Profile
          .select('profiles.*, COUNT(orders.id) AS o_count')
          .joins(:orders)
          .where(orders: { state: 'published' })
          .where.not(photo_file_name: nil)
          .customers
          .includes(:company)
          .order(deal_counter: :desc)
          .group(:id)
          .distinct

        render json: {
          objects: ::Customers::IndexSerializer.serialized_collection(customers, params: { base_url: request.base_url })
        }
      end

      def show
        customer = Profile.customers.find(params[:id])

        render json: {
          object: ::Customers::ShowSerializer.serialized_hash(customer, params: { base_url: request.base_url })
        }
      end
    end
  end
end
