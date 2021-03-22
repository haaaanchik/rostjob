# frozen_string_literal: true

module Api
  module V1
    class Customers < Grape::API

      desc 'All logos' do
        is_array true
        success Entities::Profiles::Logo
      end

      get '/customers/logos' do
        customer_logos = Profile.customers.where.not(photo_file_name: nil)

        present customer_logos,  with: Entities::Profiles::Logo, base_url: request.base_url
      end

      desc 'Get customer by ID' do
        success Entities::Profiles::Customer
      end
      params do
        requires :id, type: Integer, desc: 'Customer ID'
      end

      get '/customers/:id' do
        customer = Profile.customers.find(params[:id])

        present customer, with: Entities::Profiles::Customer, base_url: request.base_url
      end

      desc 'Get customer orders'
      params do
        requires :id, type: Integer, desc: 'Customer ID'
      end

      get '/customers/:id/orders' do
        orders = published_orders.where(profile_id: params[:id])

        present orders, with: Entities::Order, base_url: request.base_url
      end
    end
  end
end
