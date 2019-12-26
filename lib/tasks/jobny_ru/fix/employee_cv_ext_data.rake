namespace :jobny_ru do
  namespace :fix do
    desc 'Fix employee_cv_ext_data'
    task employee_cv_ext_data: :environment do
      p 'Фиксим подробности анкеты'

      EmployeeCv.find_each do |e|
        passport = {
          seria: nil,
          number: nil,
          issuer: nil,
          code: nil,
          date: nil,
          address: nil
        }
        if e.ext_data
          ed = e.ext_data.except('passport', 'additional_info')
          passport[:seria] = ed['pser']
          passport[:number] = ed['pnum']
          passport[:code] = ed['pcode']
          passport[:date] = ed['pdate']
          passport[:address] = ed['address']
          e.update_attribute(:phone_number, ed['phone']) if !e.phone_number || e.phone_number&.empty?
          e.update_attribute(:phone_number_alt, ed['phone_alt'])
          e.update_attribute(:experience, ed['experiense'])
          e.update_attribute(:education, ed['education'])
          e.update_attribute(:remark, ed['remark'])
        end
        e.update_attribute(:passport, passport)
      end
    end
  end
end
