namespace :best_hr do
  namespace :seed do
    desc 'Creates SuperJob full config.'
    task superjob: :environment do
      p 'Создаём конфигурацию для SuperJob'

      config = SuperJob::Config.create!
      config.update(contractor_id: 134)

      p 'Создаём запрос на поиск анкет'

      query_params = {
        payment_to: 60_000,
        age_to: 50,
        period: 7,
        moveable: 2,
        keywords: [
          keys: 'Слесарь МСР',
          srws: 7,
          skwc: 'and'
        ],
        t: [782]
      }

      SuperJob::Query.create!(title: 'Слесарь МСР в Набережные Челны 60тр/мес до 50 лет',
                              query_params: query_params, config_id: config.id, active: true)
    end

    desc 'Creates SuperJob query.'
    task superjob_query: :environment do
      p 'Создаём запрос на поиск анкет'

      config = SuperJob::Config.config

      query_params = {
        payment_to: 60_000,
        age_to: 50,
        period: 7,
        moveable: 2,
        keywords: [
          keys: 'Слесарь МСР',
          srws: 7,
          skwc: 'and'
        ],
        t: [782]
      }

      SuperJob::Query.create!(title: 'Слесарь МСР в Набережные Челны 60тр/мес до 50 лет',
                              query_params: query_params, config_id: config.id, active: true)
    end
  end
end
