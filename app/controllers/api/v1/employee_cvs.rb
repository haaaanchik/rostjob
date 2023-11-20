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


      desc 'Create new employee cv and send it to order',
           success: Entities::EmployeeCv
      params do
        optional :employee_cv, type: Hash do
          requires :order_id, type: Integer, desc: 'Order ID'
          requires :name, type: String, desc: 'Employee name'
          requires :phone_number, type: String, desc: 'Employee phone number, format: +7(999)-999-99-99'
          optional :gender, type: String, values: %w[М Ж], default: 'М', desc: 'Employee gender'
          optional :experience, type: String, desc: 'Employee experience'
          optional :education, type: String, desc: 'Employee education'
          optional :remark, type: String, desc: 'Employee remark'
        end
        requires :interview_date, type: Date, default: Date.current, desc: 'Employee interview date'
      end
      get '/employee_cvs/create_as_sent' do
        profile = User.find_by(email: 'myjobox@rostjob.com').profile
        order = Order.find(params[:employee_cv][:order_id])

        result = Cmd::Api::EmployeeCvs::CreateAsSent.call(employee_cvs_params: params[:employee_cv],
                                                          interview_date: params[:interview_date],
                                                          profile: profile,
                                                          order: order)

        if result.success?
          present result.employee_cv, with: Entities::EmployeeCv
        else
          error_msg = result.errors

          if result.employee_cv && result.employee_cv.errors.present?
            error_msg = result.employee_cv.errors.messages.values.join('\n')
          end

          if result.proposal_employee && result.proposal_employee.errors.present?
            error_msg = result.proposal_employee.errors.messages.values.join('\n')
          end

          error!({ errors: error_msg }, 422)
        end
      end
    end
  end
end
