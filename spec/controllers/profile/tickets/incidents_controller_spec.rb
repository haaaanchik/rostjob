require 'rails_helper'

RSpec.describe Profile::Tickets::IncidentsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:profile) { create(:profile) }
  let(:user) { create(:user, password: '12345678', confirmed_at: Time.current, profile: profile) }
  let(:employee_cv) { create(:employee_cv, profile: profile) }
  let(:customer_profile) { create(:profile, profile_type: 'customer') }
  let(:order) { create(:order, profile: customer_profile, accepted: true) }
  let(:candidate) { create(:proposal_employee, profile: profile, employee_cv: employee_cv, order: order) }

  before do
    sign_in user
  end

  describe 'GET #new' do
    it 'returns http success' do
      get :new, xhr: true
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    subject(:perform) { post :create, params: incident_params }

    let(:incident_params) do
      {
        incident: { title: 'Employer was drunk',
                    proposal_employee_id: candidate.id,
                    messages_attributes: { '0' => { text: 'WTF?' } } }
      }
    end

    it 'returns http redirect code' do
      perform
      expect(response).to have_http_status(:redirect)
    end

    it 'returns location header is equal to profile_tickets_url' do
      perform
      expect(response.headers['Location']).to eq(profile_tickets_url)
    end

    it 'creates ticket of type Incident' do
      expect { perform }.to change(Incident, :count)
    end

    it 'has state "Opened"' do
      perform

      expect(Incident.last.state).to eq('opened')
    end

    it 'creates message connected to this ticket' do
      perform
      expect(Incident.last.messages.count).to eq(1)
    end
  end
end
