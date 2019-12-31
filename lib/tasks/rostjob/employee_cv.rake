namespace :rostjob do
  namespace :seed do
    desc 'Creates employer.'
    task :employee_cv, [:profile_id] => [:environment] do |t, args|
      p 'Создаём анкету'
      employee_cv_hash = {
        name: Faker::Name.name,
        birthdate: Faker::Date.between(60.years.ago, 18.years.ago),
        profile_id: args[:profile_id],
        phone_number: Faker::PhoneNumber.phone_number,
        ext_data: {
          pser: Faker::Number.number(4),
          pnum: Faker::Number.number(6),
          pdate: Faker::Date.between(60.years.ago, 18.years.ago),
          pcode: Faker::Number.number(6),
          address: Faker::Address.full_address,
          phone_alt: Faker::PhoneNumber.phone_number,
          education: Faker::Lorem.paragraph,
          experiense: Faker::Number.between(1, 20),
          remark: Faker::Lorem.paragraph(10)
        }
      }

      cv = EmployeeCv.create! employee_cv_hash
      cv.make_ready!
    end
  end
end
