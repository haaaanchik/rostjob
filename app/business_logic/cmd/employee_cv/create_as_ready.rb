module Cmd
  module EmployeeCv
    class CreateAsReady
      include Interactor

      def call
        @result = Cmd::EmployeeCv::Create.call(params: context.params, profile: context.profile)
        context.employee_cv = @result.employee_cv
        context.fail! unless @result.success?
        @result = Cmd::EmployeeCv::ToReady.call(employee_cv: @result.employee_cv,
                                                create_reminder: @result.employee_cv.reminder?)
        send_to_order if interview_date.present? && @result.success?
        context.fail! unless @result.success?
      end

      private

      def interview_date
        context.interview_date
      end

      def order
        context.order
      end

      def current_profile
        context.current_profile
      end

      def send_to_order
        Cmd::Order::AddToFavorites.call(order: order, profile: current_profile)
        result = Cmd::ProposalEmployee::Create.call(profile: current_profile,
                                                    params: proposal_employee_params)
        if result.success?
          Cmd::EmployeeCv::ToSent.call(employee_cv: @result.employee_cv, log: false)
        end
      end

      def proposal_employee_params
        {
          order_id: order.id,
          employee_cv_id: @result.employee_cv.id,
          interview_date:  interview_date
        }
      end
    end
  end
end
