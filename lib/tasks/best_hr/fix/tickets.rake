namespace :best_hr do
  namespace :fix do
    desc 'Fix tickets'
    task tickets: :environment do
      p 'Заполняем тикеты данными'
      ProposalEmployee.find_each do |pe|
        if pe.complaints.any?
          first_complaint = pe.complaints.first
          ticket_creator = first_complaint.profile.user
          ticket_created_at = first_complaint.created_at
          ticket_state = pe.disputed? ? 'opened' : 'closed'
          incident = Incident.create!(title: 'Другое', user: ticket_creator,
                                      state: ticket_state, proposal_employee_id: pe.id,
                                      created_at: ticket_created_at)
          pe.complaints.order(id: :asc).each do |c|
            message_params = {}
            message_params[:text] = c[:text].presence || 'тест'
            message_params[:sender_name] = c.profile.user.full_name
            message_params[:sender_id] = c.profile.user.id
            message_params[:created_at] = c.created_at
            incident.messages.create!(message_params)
          end
        end
      end
    end
  end
end
