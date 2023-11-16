# frozen_string_literal: true

module Api
  module V1
    class EmployeeCvs < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'List of employee cvs',
           is_array: true,
           success: Entities::EmployeeCv
      params do
        optional :search, type: Hash do
          optional :name, type: String, desc: 'Search by employee name'
        end
        use :pagination_filters
      end
      get '/employee_cvs' do
        params[:search] = {} if params[:search].blank?

        q = EmployeeCv.ransack(name_cont: params[:search][:name], state_not_eq: 'draft')
        employee_cvs = q.result.page(params[:page]).per(params[:per]).includes(:proposal_employees)

        present :employee_cvs, employee_cvs, with: Entities::EmployeeCv
      end


      desc 'Checking employee cv to order'
      params do
        requires :name, type: String, desc: 'Employee name'
        requires :phone, type: Integer, desc: 'Enter numbers only, example 79991112233'
        requires :order_id, type: Integer, desc: 'Order ID to check'
      end
      get '/employee_cvs/check_in_order' do
        employee_cv = EmployeeCv
          .where("REGEXP_REPLACE(phone_number,'[^0-9]+','') = ?", params[:phone])
          .where(name: params[:name].strip, state: %w[sent disputed]).take

        if employee_cv.blank?
          present :result, false
        else
          present :result, employee_cv.order_id == params[:order_id]
        end
      end
    end
  end
end
