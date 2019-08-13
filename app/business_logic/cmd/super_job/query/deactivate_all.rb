module Cmd
  module SuperJob
    module Query
      class DeactivateAll
        include Interactor

        def call
          ::SuperJob::Query.update_all(active: false)
        end
      end
    end
  end
end
