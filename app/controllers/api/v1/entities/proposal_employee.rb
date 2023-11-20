# frozen_string_literal: true

module Api
  module V1
    module Entities
      class ProposalEmployee < Api::V1::Entities::Base
        expose :id,
               documentation: {
                 desc: 'Id.',
                 type: Integer
               }
        expose :email,
               documentation: {
                 desc: 'Email.',
                 type: String
               }
        expose :proposal_id,
               documentation: {
                 desc: 'Proposal id.',
                 type: Integer
               }
        expose :order_id,
               documentation: {
                 desc: 'Order id.',
                 type: Integer
               }
        expose :name,
               documentation: {
                 desc: 'Name.',
                 type: String
               }
        expose :phone_number,
               documentation: {
                 desc: 'Phone Number.',
                 type: String
               }
        expose :gender,
               documentation: {
                 desc: 'Gender.',
                 type: String
               }
        expose :document,
               documentation: {
                 desc: 'Document.',
                 type: String
               }
        expose :remark,
               documentation: {
                 desc: 'Remark.',
                 type: String
               }
        expose :education,
               documentation: {
                 desc: 'Education.',
                 type: String
               }
        expose :experience,
               documentation: {
                 desc: 'Experience.',
                 type: String
               }
        expose :reminder,
               documentation: {
                 desc: 'Reminder.',
                 type: String
               }
        expose :comment,
               documentation: {
                 desc: 'Comment.',
                 type: String
               }
        expose :created_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Proposal Employee create time in iso8601 format.'
        }
        expose :updated_at, format_with: :iso8601, documentation: {
          type: DateTime,
          desc: 'Proposal Employee update time in iso8601 format.'
        }
      end
    end
  end
end
