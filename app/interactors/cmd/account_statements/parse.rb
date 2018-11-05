module Cmd
  module AccountStatements
    class Parse
      include Interactor

      def call
        file = context.file
        path = file.tempfile.path
        result = ClientBankExchange.parse_file path
        context.fail!(errors: result[:errors]) unless result[:errors].empty?
        documents = result[:documents].select do |document|
          document[:СекцияДокумент] == "Платежное поручение\r"
        end
        context.fail!(errors: 'Выписка с чужого р/с') if foreign_documents?(documents)
        context.documents = documents
      end

      private

      def foreign_documents?(documents)
        account_number = Company.own_active.accounts.first.account_number
        foreign_documents = documents.reject do |doc|
          [doc[:ПлательщикРасчСчет], doc[:ПолучательРасчСчет]].include? account_number
        end
        !foreign_documents.empty?
      end
    end
  end
end
