# frozen_string_literal: true

module Api
  module V1
    class EmployeeCvs < Grape::API
      desc 'Add new employee_cv'
      params do
        optional :employee_cv, type: Hash do
          requires :name, type: String, desc: 'Name of candidate'
          requires :phone_number, type: String, desc: 'Сontact phone number'
          requires :gender, type: String, values: ['М', 'Ж'], default: 'М', desc: 'Gender'
          optional :education, type: String, desc: 'Education candidate'
          optional :remark, type: String, desc: 'Remark about candidate'
          optional :experience, type: String, desc: 'Candidate experience'
        end
        requires :slug, type: String, desc: 'User unique slug'
      end

      post '/employee_cvs/create' do
        user = User.find_by(slug: params[:slug])

        if user.blank?
          raise Errors.new(text: 'User not found',
                           code: 404,
                           status: 404)
        end

        result = Cmd::EmployeeCv::CreateAsReady.call(profile: user.profile,
                                                     employee_cvs_params: params[:employee_cv])

        if result.success?
          { status: :created }
        else
          error_msg = result.employee_cv.errors.full_messages.join(', ')
          raise Errors.new(text: "Ошибка сохранения анкеты: #{error_msg}",
                           code: 422,
                           status: 422)
        end
      end
    end
  end
end
