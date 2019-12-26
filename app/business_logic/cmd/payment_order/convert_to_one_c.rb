module Cmd
  module PaymentOrder
    class ConvertToOneC
      include Interactor

      def call
        output_file_path = '/tmp/from-jobny-ru.txt'
        payment_orders = context.payment_orders
        date_from = context.date_from
        date_to = context.date_to
        content = create_exchange_data(payment_orders, date_from, date_to)
        create_exchange_file(output_file_path, content)
        context.file = output_file_path
      end

      private

      def create_exchange_data(payment_orders, date_from, date_to)
        data = []
        data.push header
        data += general_info
        data.push selection_conditions(date_from, date_to)
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
          ДатаСоздания: Time.current.strftime('%d.%m.%Y'),
          ВремяСоздания: Time.current.strftime('%H:%M:%S')
        }.collect { |k, v| "#{k}=#{v}" }
      end

      def selection_conditions(date_from, date_to)
        {
          ДатаНачала: date_from.strftime('%d.%m.%Y'),
          ДатаКонца: date_to.strftime('%d.%m.%Y'),
          РасчСчет: Company.own_active.accounts.first.account_number,
          Документ: 'Платежное поручение'
        }.collect { |k, v| "#{k}=#{v}" }
      end

      def section_document(payment_order)
        data = payment_order.data
        result = {
          СекцияДокумент: 'Платежное поручение',
          Номер: data['number'],
          Дата: Time.zone.parse(data['date']).strftime('%d.%m.%Y'),
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
        }
        result.merge! tax_payment_fields(payment_order) if payment_order.data.key? 'tax_payment_fields'
        result.collect { |k, v| "#{k}=#{v}" }.push end_of_document
      end

      def tax_payment_fields(payment_order)
        tax_payment_fields = payment_order.data['tax_payment_fields']
        {
          СтатусСоставителя: tax_payment_fields['f101'],
          ПоказательКБК: tax_payment_fields['kbk'],
          ОКАТО: tax_payment_fields['oktmo'],
          ПоказательОснования: tax_payment_fields['f106'],
          ПоказательПериода: tax_payment_fields['f107'],
          ПоказательНомера: tax_payment_fields['f108'],
          ПоказательДаты: tax_payment_fields['f109'],
          Код: tax_payment_fields['uin']
        }
      end

      def end_of_document
        'КонецДокумента'
      end

      def end_of_file
        'КонецФайла'
      end
    end
  end
end
