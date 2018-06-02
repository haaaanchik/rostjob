namespace :best_hr do
  namespace :seed do
    desc 'Creates moderator.'
    task moderator: :environment do
      p 'Создаём модератора'
      admin = Staffer.create!(name: 'Администратор сервиса', login: 'moderator',
                              password: 'VjlthfnjhCthdbcf1')
      admin.add_role :moderator
    end
  end
end
