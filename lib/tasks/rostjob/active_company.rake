namespace :rostjob do
  namespace :seed do
    desc 'Creates active company and account.'
    task active_company: :environment do
      p 'Создаём активную компанию'
      company = Company.new(name: "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ \"БЭСТ-ЭЙЧАР\"",
                            short_name: "ООО \"БЭСТ-ЭЙЧАР\"",
                            address: 'Респ Татарстан, г Набережные Челны, ул Академика Рубаненко, д 6, оф 143',
                            mail_address: 'Респ Татарстан, г Набережные Челны, ул Академика Рубаненко, д 6, оф 143',
                            phone: '332-332', fax: '442-442',email: 'best-hr@best-hr.ru',
                            inn: '1650365000',
                            kpp: '165001001',
                            ogrn: '1181690044766',
                            director: 'Кушнарев Алексей Владимирович',
                            acts_on: 'устава',
                            own_company: true,
                            active: true,
                            legal_form: 'company'
      )
      company.save(validate: false)
      p 'Активная компания успешно создана'
      p 'Создаём активный аккаунт для активной компании'
      account = Account.new(account_number: '40702810629140004086',
                            corr_account: '30101810200000000824',
                            bic: '042202824',
                            bank: "ФИЛИАЛ \"НИЖЕГОРОДСКИЙ\" АО \"АЛЬФА-БАНК\"",
                            bank_address: 'г Нижний Новгород, ул Белинского, д 61',
                            accountable_type: 'Company',
                            accountable_id: company.id,
                            active: true
      )
      account.save(validate: false)
      p 'Активный аккаунт успешно создан'
    end
  end
end
