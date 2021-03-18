# frozen_string_literal: true

module Api
  module V1
    class EmployeeCvs < Grape::API
      desc 'set new employee_cv'
      params do
        requires :name, type: String, desc: 'Name of candidate'
        requires :gender, type: String, desc: 'Gender'
        requires :education, type: String, desc: 'Education candidate'
        requires :remark, type: String, desc: 'remark about candidate'
        requires :experience, type: String, desc: 'candidate experience'
        requires :phone_number, type: String, desc: 'contact phone number'
        optional :profile_id, type: Integer, desc: 'belongs_to profile'
        optional :comment, type: String, desc: 'text notify for recruter'
        optional :reminder, type: Date, desc: 'date of display notification'
      end

      post '/employee_cvs' do
        params['state'] = 'ready'
        cv = EmployeeCv.new(params)
        if cv.save
          { status: :created, cv: cv }
        else
          raise Errors.new(text: cv.errors.messages,
                           code: nil,
                           status: 422)
        end
      end
    end
  end
end
