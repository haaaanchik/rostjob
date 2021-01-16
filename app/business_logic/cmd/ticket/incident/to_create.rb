# frozen_string_literal: true

module Cmd
  module Ticket
    module Incident
      class ToCreate
        include Interactor

        delegate :user, to: :context

        def call
          incident = ::Incident.new(incident_params)
          context.incident = incident.decorate
          context.proposal_employee = proposal_employee
          context.fail! unless context.incident.save
          context.incident.to_contractor! if user.profile.contractor?
          Cmd::UserActionLogger::Log.call(params: logger_params)
        end

        private

        def incident_params
          context.incident_params.merge(
            user_id: user.id,
            messages_attributes: { '0' => messages_attributes.merge(sender_name: sender_name, sender_id: user.id) }
          )
        end

        def messages_attributes
          context.incident_params['messages_attributes']['0']
        end

        def sender_name
          user.full_name
        end

        def proposal_employee
          @proposal_employee ||= ::ProposalEmployee.find(incident_params[:proposal_employee_id])
        end

        def employee_cv
          @employee_cv = context.employee_cv = proposal_employee.employee_cv
        end

        def logger_params
          {
            login: user.email,
            receiver_ids: [user.id],
            subject_id: user.id,
            subject_type: 'User',
            subject_role: user.profile.profile_type,
            action: "Открыт спор по анкете №#{employee_cv.id} #{employee_cv.name}",
            object_id: employee_cv.id,
            object_type: 'EmployeeCv',
            employee_cv_id: employee_cv.id
          }
        end
      end
    end
  end
end
