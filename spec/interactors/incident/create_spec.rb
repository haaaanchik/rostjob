require 'rails_helper'

RSpec.feature 'Incident::Create', type: :interactor do
  describe "create incident" do
    let(:candidate) { create(:proposal_employee, :interview) }
    let(:incident_params) do
      {
        title: "other",
        proposal_employee_id: candidate.id.to_s,
        'messages_attributes' => {
          "0" => {
            "text" => "reason for call"
          }
        }
      }
    end
    let(:result) do
      Cmd::Ticket::Incident::Create.call(user: candidate.user,
                                         incident_params: incident_params)
    end

    it { expect(result).to be_a_success }
    it { expect(result.incident.opened?).to be(true) }
    it { expect(result.incident.messages.last.text).to eq('reason for call') }
    it { expect { result }.to change { ActionMailer::Base.deliveries.size }.by(1) }
  end
end
