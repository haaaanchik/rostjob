module Cmd
  module PaymentOrder
    class ConvertToOneC
      include Interactor

      def call
        output_file_path = '/tmp/from-best-hr.txt'
        payment_orders = context.payment_orders
        content = create_exchange_data(payment_orders)
        create_exchange_file(output_file_path, content)
        context.file = output_file_path
      end

      private

      def create_exchange_data(payment_orders)
        data = []
        data.push header
        data += general_info
        data.push selection_conditions
        payment_orders.each do |payment_order|
          data += section_document(payment_order)
        end
        data.push end_of_file
        data.join("\r\n")
      end

      def create_exchange_file(path, content)
        File.open(path, 'w:windows-1251') do |f|
          f.write(content)
        end
      end

      def header
        '1CClientBankExchange'
      end

      def general_info
        {
          ВерсияФормата: '1.01',
          Кодировка: 'Windows',
          Отправитель: '',
          Получатель: '',
          ДатаСоздания: Time.now.strftime('%d.%m.%Y'),
          ВремяСоздания: Time.now.strftime('%H:%M:%S')
        }.collect { |k, v| "#{k}=#{v}" }
      end

      def selection_conditions
        {
          ДатаНачала: '',
          ДатаКонца: '',
          РасчСчет: Company.own_active.accounts.first.account_number,
          Документ: 'Платёжное поручение'
        }.collect { |k, v| "#{k}=#{v}" }
      end

      def section_document(payment_order)
        data = payment_order.data
        {
          СекцияДокумент: 'Платёжное поручение',
          Номер: data['number'],
          Дата: Time.parse(data['date']).strftime('%d.%m.%Y'),
          Сумма: data['amount'],
          ПлательщикСчет: data['payer']['account']['account_number'],
          Плательщик: "ИНН #{data['payer']['inn']} #{data['payer']['name']}",
          ПлательщикИНН: data['payer']['inn'],
          Плательщик1: data['payer']['name'],
          ПлательщикРасчСчет: data['payer']['account']['account_number'],
          ПлательщикБанк1: data['payer']['account']['bank'],
          ПлательщикБанк2: data['payer']['account']['bank_address'],
          ПлательщикБИК: data['payer']['account']['bic'],
          ПлательщикКорСчет: data['payer']['account']['corr_account'],
          ПолучательСчет: data['receiver']['account']['account_number'],
          Получатель: "ИНН #{data['receiver']['inn']} #{data['receiver']['name']}",
          ПолучательИНН: data['receiver']['inn'],
          Получатель1: data['receiver']['name'],
          ПолучательРасчСчет: data['receiver']['account']['account_number'],
          ПолучательБанк1: data['receiver']['account']['bank'],
          ПолучательБанк2: data['receiver']['account']['bank_address'],
          ПолучательБИК: data['receiver']['account']['bic'],
          ПолучательКорСчет: data['receiver']['account']['corr_account'],
          ВидПлатежа: data['type_of_payment'],
          ВидОплаты: data['kind_of_payment'],
          ПлательщикКПП: data['payer']['kpp'],
          ПолучательКПП: data['receiver']['kpp'],
          Очередность: data['priority'],
          НазначениеПлатежа: data['purpose_of_payment'],
          НазначениеПлатежа1: data['purpose_of_payment']
        }.collect { |k, v| "#{k}=#{v}" }
      end

      def end_of_file
        'КонецФайла'
      end
    end
  end
end
