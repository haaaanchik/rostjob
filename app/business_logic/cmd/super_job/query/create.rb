module Cmd
  module SuperJob
    module Query
      class Create
        include Interactor

        def call
          query = ::SuperJob::Config.config.queries.create(params)
          context.query = query
          context.fail! unless query.persisted?
          context.query.update(active: true) if ::SuperJob::Query.active.none?
          context.fail! unless query.persisted?
        end

        private

        def params
          context.params
        end
      end
    end
  end
end
