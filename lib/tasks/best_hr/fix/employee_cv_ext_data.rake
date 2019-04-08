namespace :best_hr do
  namespace :fix do
    desc 'Fix employee_cv_ext_data'
    task employee_cv_ext_data: :environment do
      p 'Фиксим подробности анкеты'

      EmployeeCv.find_each do |e|
        passport = {}
        ed = e.ext_data.except('passport', 'additional_info')
        if ed
          passport[:seria] = ed['pser']
          passport[:number] = ed['pnum']
          passport[:issuer] = nil
          passport[:code] = ed['pcode']
          passport[:data] = ed['pdate']
          passport[:address] = ed['address']
          e.update_attribute(:passport, passport)
          e.update_attribute(:phone_number, ed['phone']) if !e.phone_number || e.phone_number&.empty?
          e.update_attribute(:experience, ed['experiense'])
          e.update_attribute(:education, ed['education'])
          e.update_attribute(:remark, ed['remark'])
          e.update_attribute(:phone_number_alt, ed['phone_alt'])
        end
      end
    end
  end
end
