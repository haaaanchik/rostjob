module Cmd
  module SuperJob
    module Resumes
      class CreateAsReady
        include Interactor

        def call
          resumes = client.all_resumes_with_contacts
          config = ::SuperJob::Config.config
          current_query = query || config.active_query
          query_params = current_query.query_params
          title = current_query.title
          profile = ::User.find(config.contractor_id).profile

          resumes.each do |resume|
            params = {
              name: resume[:link],
              phone_number: resume[:phone],
              super_job_id: resume[:resume_id],
              gender: resume[:gender],
              experience: query_params['keywords'][0]['keys'],
              remark: "#{title}\n#{query_params}"
            }
            Cmd::EmployeeCv::CreateAsReady.call(params: params, profile: profile)
          end
        end

        private

        def query
          context.query
        end

        def client
          @client = SuperJobApi::Client.new(::SuperJob::Config.config, query)
        end
      end
    end
  end
end
