module Cmd
  module SuperJob
    module Query
      class Update
        include Interactor

        def call
          context.fail! unless query.update(params)
        end

        private

        def query
          context.query
        end

        def params
          context.params
        end
      end
    end
  end
end
