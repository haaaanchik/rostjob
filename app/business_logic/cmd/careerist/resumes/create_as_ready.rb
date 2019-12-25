module Cmd
  module Careerist
    module Resumes
      class CreateAsReady
        include Interactor

        def call
          response = search(careerist.query_params)
          unless response['data'].present?
            logger_debug(response['errors_message'])
            return
          end
          response = response['data']
          profile = ::User.find_by(email: 'bot@best-hr.pro')&.profile
          resume_save(response['list'], profile)
          number_of_pages = calculate_number_of_pages(response['count'])
          i = 2

          while i <= number_of_pages
            query_params = careerist.query_params
            response = search(query_params.merge(page: i))
            resume_save(response['data']['list'], profile)
            i += 1
          end
        end

        private

        def careerist
          context.careerist
        end

        def calculate_number_of_pages(count)
          (count / 25).to_i + 1
        end

        def resume_save(resumes, profile)
          resumes.each do |resume|
            params = {
              name: resume['url'],
              careerist_job: true,
              experience: resume['expiriens'],
              remark: "#{careerist.title}\nДолжность: #{resume['position']}\n#{careerist.query_params}",
            }
            Cmd::EmployeeCv::CreateAsReady.call(params: params, profile: profile)
          end
        end

        def search(query_params)
          CareeristApi::SearchResume.new.post_request(query_params)
        end

        def logger_debug(error_message)
          Rails.logger.debug "Careerist search resume error! #{error_message}"
        end
      end
    end
  end
end
