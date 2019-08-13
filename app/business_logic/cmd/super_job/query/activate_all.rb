module Cmd
  module SuperJob
    module Query
      class ActivateAll
        include Interactor

        def call
          ::SuperJob::Query.update_all(active: true)
        end
      end
    end
  end
end
