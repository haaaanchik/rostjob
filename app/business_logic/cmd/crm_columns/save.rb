# frozen_string_literal: true

module Cmd
  module CrmColumns
    class Save
      include Interactor

      delegate :user, to: :context
      delegate :params, to: :context
      delegate :crm_column, to: :context

      def call
        context.fail!(errors: error_message) unless form.validate(crm_column_params)

        form.save do |hash|
          form.model.assign_attributes(hash)

          form.save!
        end
      end

      private

      def crm_column_params
        {
          name: params[:name],
          user_id: user.id
        }
      end

      def form
        @form ||= CrmColumnForm.new(crm_column)
      end

      def error_message
        form.errors.values.flatten.join("\n")
      end
    end
  end
end
