module Cmd
  module Invoice
    class Create
      include Interactor

      delegate :amount, to: :context
      delegate :company, to: :context
      delegate :invoice, to: :context
      delegate :profile, to: :context

      def call
        invoice.assign_attributes(invoice_params)
        send_invoicing if profile.customer? && invoice.valid?
        context.fail!(error: invoice.errors.full_messages[0]) unless invoice.save
        Cmd::UserActionLogger::Log.call(params: logger_params)
      end

      private

      def send_invoicing
        response = TinkoffApi::Invoicing.send_invoicing(invoice)
        context.fail!(error: response[:error]) unless response['pdfUrl'].present?
        invoice.update(tinkoff_pdf_url: response['pdfUrl'])
      end

      def seller_buyer_params
        return [Company.own_active, profile.company] if profile.customer?

        [company, Company.own_active]
      end

      def invoice_params
        seller, buyer = seller_buyer_params
        {
          amount: amount,
          seller: counterparty(seller),
          buyer: counterparty(buyer),
          goods: goods(amount)
        }
      end

      def counterparty(company)
        account = company.active_account
        {
          name: company.name,
          short_name: company.short_name,
          inn: company.private_person? ? account&.inn : company.inn,
          kpp: company.private_person? ? account&.kpp : company.kpp,
          address: company[:address],
          account: {
            account_number: account&.account_number,
            corr_account: account&.corr_account,
            bic: account&.bic,
            bank: account&.bank,
            bank_address: account&.bank_address
          }
        }
      end

      def goods(price)
        [
          {
            title: 'Услуги по размещению заявки на поиск персонала',
            unit: 'шт',
            quantity: 1,
            price: price
          }
        ]
      end

      def logger_params
        user = profile.user
        {
          login: user.email,
          receiver_ids: [user.id],
          subject_id: user.id,
          subject_type: 'User',
          subject_role: user.profile ? user.profile.profile_type : nil,
          action: "Выписан счет №#{invoice.invoice_number} на сумму #{invoice.amount}",
          object_id: invoice.id,
          object_type: 'Invoice'
        }
      end
    end
  end
end
