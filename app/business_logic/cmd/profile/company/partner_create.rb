# frozen_string_literal: true

module Cmd
  module Profile
    module Company
      class PartnerCreate
        include Interactor

        delegate :profile, to: :context

        def call
          create_company
          create_account
        end

        private

        def create_company
          context.company = profile.build_company
          context.company.legal_form = 'partner'
          context.company.save(validate: false)

          context.fail! unless context.company.persisted?
        end

        def create_account
          account = context.company.build_active_account
          account.save(validate: false)

          context.failed! unless account.persisted?
        end
      end
    end
  end
end
