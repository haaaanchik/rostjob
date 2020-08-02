module Cmd
  module Profile
    module Balance
      module WithdrawalMethod
        class CreateContractor
          include Interactor

          delegate :profile, to: :context

          def call
            %w[company ip private_person].each do |legal_form|
              ::Cmd::Profile::Balance::WithdrawalMethod::Create.call(profile: profile, legal_form: legal_form)
            end
          end
        end
      end
    end
  end
end