module Cmd
  module AccountStatements
    class Parse
      include Interactor

      def call
        file = context.file
        path = file.tempfile.path
        result = ClientBankExchange.parse_file path
        context.fail!(errors: result[:errors]) unless result[:errors].empty?
        context.documents = result[:documents]
      end
    end
  end
end
