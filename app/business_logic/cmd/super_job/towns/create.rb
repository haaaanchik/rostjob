module Cmd
  module SuperJob
    module Towns
      class Create
        include Interactor

        def call
          towns = client.towns['objects']
          ::SuperJob.config.towns.destroy_all
          towns.each do |town|
            ::SuperJob.config.towns.create(town)
          end
        end

        private

        def client
          @client = SuperJobApi::Client.new(::SuperJob.config)
        end
      end
    end
  end
end
