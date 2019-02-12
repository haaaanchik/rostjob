module Cmd
  module EmployeeCv
    class CreateAsReady
      include Interactor

      def call
        result = Cmd::EmployeeCv::Create.call(params: context.params, profile: context.profile)
        context.employee_cv = result.employee_cv
        context.fail! unless result.success?
        result = Cmd::EmployeeCv::ToReady.call(employee_cv: result.employee_cv)
        context.fail! unless result.success?
      end
    end
  end
end
