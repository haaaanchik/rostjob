# frozen_string_literal: true

module Cmd
  module EmployeeCv
    class Update
      include Interactor::Organizer

      organize Cmd::EmployeeCv::ToUpdate,
               Cmd::UserActionLogger::EmployeeCv::CreateLogCaseUpdate

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
