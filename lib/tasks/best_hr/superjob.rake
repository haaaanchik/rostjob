namespace :best_hr do
  namespace :seed do
    desc 'Creates SuperJob config.'
    task superjob: :environment do
      p 'Создаём конфигурацию для SuperJob'

      config = SuperJob.create!
      query_params = {
        period: 30,
        experience: 1,
        movable: 1,
        keywords: [
          keys: 'Слесарь МСР',
          srwc: 7,
          skwc: 'and'
        ],
        t: [782]
      }
      config.update(query_params: query_params, contractor_id: 134)
    end
  end
end
