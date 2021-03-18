# frozen_string_literal: true

module Cmd
  module EmployeeCv
    class CreateAsReady
      include Interactor::Organizer

      organize Cmd::EmployeeCv::Create,
               Cmd::EmployeeCv::ToReady

      around do |interactor|
        ActiveRecord::Base.transaction do
          interactor.call
        end
      end
    end
  end
end
