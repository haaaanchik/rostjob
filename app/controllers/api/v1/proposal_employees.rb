# frozen_string_literal: true

module Api
  module V1
    class ProposalEmployees < Grape::API
      helpers Api::V1::NamedParams

      before { user_authenticated! }

      desc 'Create new proposal employees',
           success: Entities::ProposalEmployee
      params do
        requires :email, type: String, desc: 'Email'
        requires :order_id, type: Integer, desc: 'Order id'
        requires :proposal_id, type: Integer, desc: 'Profile id'
        requires :phone_number, type: Integer, desc: 'Phone Number'
        optional :gender, type: String, desc: 'Gender'
        optional :document, type: String, desc: 'Document'
        optional :remark, type: String, desc: 'Remark'
        optional :education, type: String, desc: 'Education'
        requires :experience, type: String, desc: 'Experience'
        optional :reminder, type: Date, desc: 'Reminder'
        optional :comment, type: String, desc: 'Comment'
      end
      post '/proposal_employees' do
        byebug
        result = Cmd::ProposalEmployeeCv::Create.call(
          email: params[:email],
          order_id: params[:order_id],
          proposal_id: params[:proposal_id],
          name: params[:name],
          phone_number: params[:phone_number],
          gender: params[:gender],
          document: params[:document],
          remark: params[:remark],
          education: params[:education],
          experience: params[:experience],
          reminder: params[:reminder],
          comment: params[:comment]
        )

        if result.success?
          present result.proposal_employee, with: Entities::ProposalEmployee
        else
          error!(result.errors, 422)
        end
      end
    end
  end
end
