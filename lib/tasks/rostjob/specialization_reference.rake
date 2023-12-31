namespace :rostjob do
  namespace :seed do
    desc 'Creates specialization reference.'
    task specialization_reference: :environment do
      p 'Заполняем справочник специализаций'
      ['Розничная торговля', 'Промышленное производство', 'Грузовой транспорт',
       'Стоматология', 'Высший менеджмент', 'Информационные технологии и телеком',
       'Математика', 'ГСМ', 'Рабочий персонал'].each do |specialization|
        Specialization.create title: specialization
      end
    end
  end
end
