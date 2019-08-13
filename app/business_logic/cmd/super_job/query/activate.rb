module Cmd
  module SuperJob
    module Query
      class Activate
        include Interactor

        def call
          query.update(active: true)
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
