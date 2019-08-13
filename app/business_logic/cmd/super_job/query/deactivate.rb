module Cmd
  module SuperJob
    module Query
      class Deactivate
        include Interactor

        def call
          query.update(active: false)
          context.fail! unless query.persisted?
        end

        private

        def query
          context.query
        end
      end
    end
  end
end
