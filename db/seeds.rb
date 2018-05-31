# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Создаём работодателя
email = 'employer@test.ru'
profile_hash = {
  contact_person: Faker::Name.name,
  phone: Faker::PhoneNumber.phone_number,
  email: email,
  profile_type: 'employer',
  company_name: Faker::Company.name,
  city: Faker::Address.city
}

profile = Profile.create! profile_hash
profile.photo = File.new "#{Rails.root}/public/img/default.png"
profile.save
profile.create_balance

User.create! email: email, password: 'hf,jnjlfntkm', profile: profile, last_sign_in_at: Time.now - 2.hours

# Создаём рекрутера
profile_type = 'recruiter'
email = "recruiter@test.ru"
profile_hash = {
  contact_person: Faker::Name.name,
  phone: Faker::PhoneNumber.phone_number,
  email: email,
  profile_type: profile_type,
  company_name: Faker::Company.name,
  description: Faker::Lorem.paragraph(2),
  city: Faker::Address.city
}
profile_hash[:company_name] = Faker::Company.name

profile = Profile.create! profile_hash
profile.photo = File.new "#{Rails.root}/public/img/default.png"
profile.save

User.create! email: email, password: "htrhenth", profile: profile, last_sign_in_at: Time.now - 2.hours

# PROFESSIONS = ['Водитель погрузчика', 'Крановщик', 'Бухгалтер', 'Кассир',
#                'Продавец - консультант'].freeze
# Profile.all.each do |p|
#   if COMPANIES.include? p.profile_type
#     title = PROFESSIONS.sample
#     salary_from = (10000..100000).to_a.sample
#     5.times do |t|
#       order_hash = {
#         title: title,
#         specialization: title,
#         city: Faker::Address.city,
#         salary_from: salary_from,
#         salary_to: salary_from + 15000,
#         description: Faker::Lorem.paragraph(2),
#         commission: salary_from,
#         warranty_period: (1..3).to_a.sample,
#         number_of_recruiters: (1..5).to_a.sample,
#         payment_type: %w[zero one two].sample,
#         enterpreneurs_only: [true, false].sample,
#         requirements_for_recruiters: Faker::Lorem.paragraph(2),
#         stop_list: Faker::Lorem.paragraph(2),
#         accepted: true
#       }
#       o = p.orders.create! order_hash
#       o.update(created_at: Time.now - (0..30).to_a.sample.days)
#       message = %i[publish! complete!].sample
#       o.send message
#     end
#   end
# end

# executors = Profile.where.not(profile_type: 'employer')
# Order.published.each do |o|
#   current_profile = executors.sample
#   proposal_hash = {
#     description: Faker::Lorem.paragraph(2),
#     order_id: o.id
#   }
#   proposal = current_profile.proposals.create! proposal_hash
#   message = %i[accept! reject!].sample
#   proposal.send message
# end

# 3.times do
#   Proposal.accepted.sample.complete!
# end

p 'Заполняем справочник городов'
%w[Абакан Альметьевск Ангарск Арзамас Армавир Артем Архангельск Астрахань Ачинск Балаково Балашиха
Барнаул Батайск Белгород Бердск Березники Бийск Благовещенск Братск Брянск  Владивосток
Владикавказ Владимир Волгоград Волгодонск Волжский Вологда Воронеж Грозный Дербент Дзержинск Димитровград
Долгопрудный Домодедово Евпатория Екатеринбург Елец Ессентуки Железногорск Жуковский Златоуст
Иваново Ижевск Иркутск Йошкар-Ола Казань Калининград Калуга Каменск-Уральский Камышин Каспийск
Кемерово Керчь Киров Кисловодск Ковров Коломна Комсомольск-на-Амуре Копейск Королёв Кострома
Красногорск Краснодар Красноярск Курган Курск Кызыл Липецк Люберцы Магнитогорск Майкоп Махачкала
Миасс Москва Мурманск Муром Мытищи  Назрань Нальчик Находка Невинномысск Нефтекамск
Нефтеюганск Нижневартовск Нижнекамск   Новокузнецк Новокуйбышевск
Новомосковск Новороссийск Новосибирск Новочебоксарск Новочеркасск Новошахтинск Новый Уренгой
Ногинск Норильск Ноябрьск Обнинск Одинцово Октябрьский Омск Орёл Оренбург Орехово-Зуево Орск
Пенза Первоуральск Пермь Петрозаводск Петропавловск-Камчатски Подольск Прокопьевск Псков
Пушкино Пятигорск Раменское Ростов-на-Дону Рубцовск Рыбинск Рязань Салават Самара Санкт-Петербург
Саранск Саратов Севастополь Северодвинск Северск  Серпухов Симферополь Смоленск
Сочи Ставрополь  Стерлитамак Сургут Сызрань Сыктывкар Таганрог Тамбов Тверь
Тольятти Томск Тула Тюмень Улан-Удэ Ульяновск Уссурийск Уфа Хабаровск Хасавюрт Химки Чебоксары
Челябинск Череповец Черкесск Чита Шахты Щёлково Электросталь Элиста Энгельс Южно-Сахалинск
Якутск Ярославль]. each do |city|
  CityReference.create term: city
end
['Великий Новгород', 'Набережные Челны', 'Нижний Новгород', 'Нижний Тагил', 'Сергиев Посад', 'Старый Оскол'].each do |city|
  CityReference.create term: city
end

p 'Заполняем справочник специализаций'
%w[продавец токарь водитель врач директор программист учитель кладовщик грузчик].each do |specialization|
  SpecializationReference.create term: specialization
end

# Создаём админа сервиса
admin = Staffer.create!(name: 'Администратор сервиса', login: 'admin', password: 'YjdsqHRCthdbc1')
admin.add_role :admin
