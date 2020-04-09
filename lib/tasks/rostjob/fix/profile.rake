namespace :rostjob do
  namespace :fix do
    desc 'Fix profiles data'
    task profiles: :environment do
      p 'Добавляем шаблон компании к профилям'
      template_company = {
        name: 'Общество с ограниченной ответственностью «РостДжоб»',
        short_name: 'ООО «РостДжоб»',
        address: '423810, Республика Татарстан, г. Набережные Челны, ул. Академика Рубаненко, д.4, оф 359',
        mail_address: '423810, Республика Татарстан, г. Набережные Челны, ул. Академика Рубаненко, д.4, оф 359',
        phone: '(909) 312-26-00',
        fax: '442-442',
        email: 'rostjob@rostjob.com',
        ogrn: '1201600027144',
        inn: '1650390021',
        kpp: '165001001',
        director: 'Юсупова Мария Васильевна',
        acts_on: 'действует на основании Устава',
        accounts_attributes: [{
          account_number: '40702810729140006353',
          corr_account: '30101810200000000824',
          bic: '042202824',
          bank: 'Филиал «Нижегородский» АО «Альфа-Банк»',
          bank_address: 'г. Набережные Челны'
        }]
      }
      users = User.select { |u| u.profile.company.nil? }
      users.each { |u| u.profile.create_company(template_company) }
    end
  end
end
