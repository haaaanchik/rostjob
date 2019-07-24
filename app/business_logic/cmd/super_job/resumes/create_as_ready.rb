module Cmd
  module SuperJob
    module Resumes
      class CreateAsReady
        include Interactor

        def call
          resumes = client.all_resumes_with_contacts
          config = ::SuperJob.config
          query_params = config.query_params
          profile = ::User.find(config.contractor_id).profile

          resumes.each do |resume|
            params = {
              name: resume[:link],
              phone_number: resume[:phone],
              super_job_id: resume[:resume_id],
              experience: query_params['keywords'][0]['keys'],
              remark: query_params.to_s
            }
            Cmd::EmployeeCv::CreateAsReady.call(params: params, profile: profile)
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
