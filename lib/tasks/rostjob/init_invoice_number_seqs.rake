namespace :rostjob do
  namespace :seed do
    desc 'Initialize invoice number sequense'
    task init_invoice_number_seqs: :environment do
      p 'Инициализируем последовательность номеров счетов'
      ActiveRecord::Base.connection
                        .execute('insert into invoice_number_seqs(invoice_number) values(0)')
    end
  end
end
