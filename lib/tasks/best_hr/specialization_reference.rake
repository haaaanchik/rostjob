namespace :best_hr do
  namespace :seed do
    desc 'Creates specialization reference.'
    task specialization_reference: :environment do
      p 'Заполняем справочник специализаций'
      ['Розничная торговля', 'Промышленное производство', 'Грузовой транспорт',
       'Стоматология', 'Высший менеджмент', 'Информационные технологии и телеком',
       'Математика', 'ГСМ', 'Рабочий персонал'].each do |specialization|
        SpecializationReference.create term: specialization
      end
    end
  end
end
