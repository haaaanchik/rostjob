# frozen_string_literal: true

module Cmd
  module ProposalEmployee
    module Approve
      class ToApprove
        include Interactor

        delegate :candidate, to: :context

        def call
          context.fail! if candidate.approved_by_admin

          candidate.update_attribute(:approved_by_admin, true)
        end
      end
    end
  end
end
