namespace :rostjob do
  namespace :seed do
    desc 'Creates position reference.'
    task position_reference: :environment do
      p 'Заполняем справочник профессий'
      load File.join(Rails.root, 'db', 'seeds', 'positions.rb')
    end
  end
end
