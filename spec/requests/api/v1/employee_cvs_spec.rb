require 'rails_helper'

RSpec.describe "Api::V1::EmployeeCvs", type: :request do
  describe 'create new cv' do
    let(:employee_cv) { attributes_for(:employee_cv) }
    let(:contractor) { create(:contractor) }

    before { post '/api/v1/employee_cvs', params: employee_cv }
    subject { response }

    it { expect(response).to have_http_status(:success) }
    it 'should to create new cv' do
      expect {
        post '/api/v1/employee_cvs', params: employee_cv
      }.to change(EmployeeCv, :count)
    end
  end

  describe 'dont create new cv withou paramets' do
    before { post '/api/v1/employee_cvs', params: nil }
    subject { response }

    it { expect(response).to have_http_status(400) }
  end
end