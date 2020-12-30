module Cmd
  module UserActionLogger
    module EmployeeCv
      class CreateLogCaseUpdate
        include Interactor

        delegate :user,        to: :context
        delegate :params,      to: :context
        delegate :employee_cv, to: :context

        def call
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def generate_respond_action
          default_text = "Анкета №#{employee_cv.id} #{employee_cv.name} отредактирована "

          employee_cv.previous_changes.each do |attr_name, changes|
            next if attr_name.include?('created_at') || attr_name.include?('updated_at')

            changet_str = "#{::EmployeeCv.human_attribute_name(attr_name)} c #{changes.first} на #{changes.last}"
            text = "<br> Было изменено значение #{changet_str}"
            default_text.concat(text)
          end

          default_text
        end

        def admin?
          @admin = user.is_a?(Staffer)
        end

        def login
          admin? ? user.login : user.email
        end

        def subject_role
          admin? ? user.role_list.first : user.profile.profile_type
        end

        def logger_params
          {
            login: login,
            receiver_ids: [user.id],
            subject_id: user.id,
            subject_type: user.class.to_s,
            subject_role: subject_role,
            action: generate_respond_action,
            object_id: employee_cv.id,
            object_type: 'EmployeeCv',
            employee_cv_id: employee_cv.id
          }
        end
      end
    end
  end
end
