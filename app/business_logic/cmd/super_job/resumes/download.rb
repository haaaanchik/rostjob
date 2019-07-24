module Cmd
  module SuperJob
    module Resumes
      class Download
        include Interactor

        def call
          context.employee_cvs = ready_employee_cvs.map do |ecv|
            ecv.phone_number.delete!(' \-+').sub!(/^./, '8')
            ecv
          end
        end

        private

        def params
          context.params
        end

        def user
          User.find_by(email: 'bot@best-hr.pro')
        end

        def profile
          user.profile
        end

        def ready_employee_cvs
          from = Time.zone.parse(params[:date_from]).beginning_of_day
          to = Time.zone.parse(params[:date_to]).end_of_day
          profile.employee_cvs.ready.where(created_at: [from..to])
          # profile.employee_cvs.ready
        end
      end
    end
  end
end
