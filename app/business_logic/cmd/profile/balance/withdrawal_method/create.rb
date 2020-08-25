module Cmd
  module Profile
    module Balance
      module WithdrawalMethod
        class Create
          include Interactor

          delegate :profile, to: :context
          delegate :legal_form, to: :context

          def call
            context.failed! unless profile.contractor?
            wm = profile.withdrawal_methods.create(type: type)
            context.failed! unless wm.persisted?
            company = wm.create_company(legal_form: legal_form)
            context.failed! unless company.persisted?
            account = company.accounts.create
            context.failed! unless account.persisted?
          end

          private

          def type
            "WithdrawalMethod::#{method}".constantize
          end

          def method
            (legal_form + '_account').camelize
          end
        end
      end
    end
  end
end
