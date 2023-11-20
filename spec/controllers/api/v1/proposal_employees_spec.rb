require 'rails_helper'

RSpec.describe API::V1::ProposalEmployees do

    user = API::V1::ProposalEmployees.create 'myjobox@rostjob.com'

    context 'when the request is valid' do
      it 'creates a proposal employee' do
        expect(user.email).to eq('myjobox@rostjob.com')
      end

      it 'returns status code 200' do
        post '/api/v1/proposal_employees', headers: { 'Authorization' => user }
        expect(response.status).to eq(200)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/proposal_employees', params: {}, headers: { 'Authorization' => user } }

      it 'returns status code 422' do
        post '/api/v1/proposal_employees', headers: { 'Authorization' => user }
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        json = JSON.parse(response.body)
        expect(json['error']).to_not be_empty
      end
    end

end
