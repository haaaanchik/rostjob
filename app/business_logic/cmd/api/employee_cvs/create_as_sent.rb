# frozen_string_literal: true

module Cmd
  module Api
    module EmployeeCvs
      class CreateAsSent
        include Interactor::Organizer

        organize Cmd::EmployeeCv::Create,
                 Cmd::EmployeeCv::ToReady,
                 Cmd::ProposalEmployee::ToCreate,
                 Cmd::EmployeeCv::ToSent

        around do |interactor|
          ActiveRecord::Base.transaction do
            interactor.call
          end
        end
      end
    end
  end
end
