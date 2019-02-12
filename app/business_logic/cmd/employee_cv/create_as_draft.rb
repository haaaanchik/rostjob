module Cmd
  module EmployeeCv
    class CreateAsDraft
      include Interactor

      def call
        result = Cmd::EmployeeCv::Create.call(params: context.params, profile: context.profile)
        context.employee_cv = result.employee_cv
        context.fail! unless result.success?
      end
    end
  end
end
