require 'rails_helper'

RSpec.describe Profile::Tickets::AppealsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:profile) { create(:profile, profile_type: 'contractor') }
  let(:user) { create(:user, password: '12345678', confirmed_at: Time.current, profile: profile) }

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
    subject(:perform) { post :create, params: appeal_params }

    let(:appeal_params) do
      {
        appeal: { title: 'Service operation',
                  messages_attributes: { '0' => { text: 'WTF? Nothing works!' } } }
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

    it 'creates ticket of type Appeal' do
      expect { perform }.to change(Appeal, :count)
    end

    it 'has state "Opened"' do
      perform

      expect(Appeal.last.state).to eq('opened')
    end

    it 'creates message connected to this ticket' do
      perform
      expect(Appeal.last.messages.count).to eq(1)
    end
  end
end
