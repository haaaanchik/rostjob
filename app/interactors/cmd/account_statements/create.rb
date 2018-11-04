# frozen_string_literal: true

module Cmd
  module AccountStatements
    class Create
      include Interactor

      def call
        documents = context.documents
        documents = documents.select do |document|
          document[:СекцияДокумент] == "Платежное поручение\r"
        end
        documents = documents.map do |document|
          {
            number: document[:Номер],
            date: document[:Дата],
            amount: document[:Сумма],
            sender: document[:Плательщик],
            src_account: document[:ПлательщикСчет],
            data: document
          }
        end
        account = Company.own_active.accounts.first
        documents.each do |doc|
          account.account_statements.create doc
        rescue StandardError
          next
        end

        # context.fail!(errors: result[:errors]) unless result[:errors].empty?
      end
    end
  end
end
