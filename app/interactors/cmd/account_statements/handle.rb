module Cmd
  module AccountStatements
    class Handle
      include Interactor

      def call
        account = context.account
        income_documents = income(account)
        income_documents.each do |doc|
          invoice = unpaid_invoice(doc.src_account, doc.amount)
          next unless invoice
          invoice.pay! if invoice.may_pay?
          invoice.profile.balance.deposit(invoice.amount, 'Пополнение баланса')
          OrderPublicationJob.perform_later(invoice.id)
        end
      end

      private

      def unpaid_invoice(account_number, amount)
        unpaid_invoices.where('buyer->"$.account.account_number" = ?', account_number)
                       .where(amount: amount).first
      end

      def unpaid_invoices
        Invoice.created
      end

      def income(account)
        documents(account).select(&:income?)
      end

      def documents(account)
        account.account_statements.uploaded
      end
    end
  end
end
