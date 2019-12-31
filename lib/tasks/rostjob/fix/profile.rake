namespace :rostjob do
  namespace :fix do
    desc 'Fix profiles data'
    task profiles: :environment do
      p 'Добавляем шаблон компании к профилям'
      template_company = {
        name: 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "БЭСТ-ЭЙЧАР"',
        short_name: 'ООО "БЭСТ-ЭЙЧАР"',
        address: 'Респ Татарстан, г Набережные Челны, ул Академика Рубаненко, д 6, оф 143',
        mail_address: 'Респ Татарстан, г Набережные Челны, ул Академика Рубаненко, д 6, оф 143',
        phone: '332-332',
        fax: '442-442',
        email: 'rostjob@rostjob.com',
        ogrn: '1181690044766',
        inn: '1650365000',
        kpp: '165001001',
        director: 'Хасанов Руслан Рамилевич',
        acts_on: 'устава',
        accounts_attributes: [{
          account_number: '40702810629140004086',
          corr_account: '30101810200000000824',
          bic: '042202824',
          bank: 'ФИЛИАЛ "НИЖЕГОРОДСКИЙ" АО "АЛЬФА-БАНК"',
          bank_address: 'г Нижний Новгород, ул Белинского, д 61'
        }]
      }
      users = User.select { |u| u.profile.company.nil? }
      users.each { |u| u.profile.create_company(template_company) }
    end
  end
end
