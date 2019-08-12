module Cmd
  module SuperJob
    module Query
      class Copy
        include Interactor

        def call
          attributes = query.attributes
          attributes.delete('active')
          double = ::SuperJob::Config.config.queries
                                     .create(attributes.merge('id' => nil, 'title' => new_title))
          context.double = double
          context.fail! unless double.persisted?
          context.double.update(active: true) if ::SuperJob::Query.active.none?
          context.fail! unless double.persisted?
        end

        private

        def new_title
          "Копия #{query.title}"
        end

        def query
          context.query
        end
      end
    end
  end
end
