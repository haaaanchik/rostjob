module Cmd
  module Profile
    module Company
      class Create
        include Interactor

        delegate :profile, to: :context

        def call
          company = profile.build_company
          company.save(validate: false)
          context.company = company
        end
      end
    end
  end
end