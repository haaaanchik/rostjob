# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApiV1Controller
      def index
        orders = ::Orders::ListService.call(params).result.page(params[:page])

        render json: {
          objects: OrderSerializer.serialized_collection(orders, params: { base_url: request.base_url }),
          page: orders.current_page,
          total_pages: orders.total_pages,
          total_count: orders.total_count
        }
      end

      def show
        order = PublishedOrdersSpecification.to_scope.find(params[:id])

        render json: {
          object: OrderSerializer.serialized_hash(order, params: { base_url: request.base_url })
        }
      end

      def favorites
        orders = PublishedOrdersSpecification.to_scope.where(id: params[:rj_order_ids])

        render json: {
          objects: OrderSerializer.serialized_collection(orders, params: { base_url: request.base_url })
        }
      end
    end
  end
end
