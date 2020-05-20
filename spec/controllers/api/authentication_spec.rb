# require 'rails_helper'

# RSpec.describe Api::V1::NomenclaturesController, type: :controller do
#   let(:api_user) { create(:user) }
#   let(:api_token) { api_user.api_token }
#   let(:contract_id) { "C000003409" }

#   describe "authentication" do
#     context "when api token don't specified" do
#       subject(:perform) { get :show, params: { api_token: nil, contract_id: contract_id } }

#       it "returns a 401 http status code" do
#         perform
#         expect(response.status).to eq(401)
#       end

#       it "response matches the schema" do
#         perform
#         expect(response).to match_response_schema("error")
#       end
#     end

#     context "when api_token specified, but it's wrong" do
#       subject(:perform) { get :show, params: { api_token: "asdfasdf", contract_id: contract_id } }

#       it "returns a 401 http status code" do
#         perform
#         expect(response.status).to eq(401)
#       end

#       it "response matches the schema" do
#         perform
#         expect(response).to match_response_schema("error")
#       end
#     end

#     context "when right api_token specified" do
#       subject(:perform) { get :show, params: { api_token: api_token, contract_id: contract_id } }

#       it "returns a 200 http status code" do
#         perform
#         expect(response.status).to eq(200)
#       end
#     end
#   end
# end
