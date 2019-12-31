namespace :rostjob do
  namespace :seed do
    desc 'Creates service admin.'
    task admin: :environment do
      p 'Создаём админа сервиса'
      admin = Staffer.create!(name: 'Администратор сервиса', login: 'admin',
                              password: 'YjdsqHRCthdbc1')
      admin.add_role :admin
    end
  end
end
