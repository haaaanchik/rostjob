module Cmd
  module SuperJob
    module Query
      class Activate
        include Interactor

        def call
          ActiveRecord::Base.transaction do
            ::SuperJob::Query.update_all(active: false)
            query.update(active: true)
          end
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
