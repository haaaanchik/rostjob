namespace :jobny_ru do
  namespace :fix do
    desc 'fix user_action_log'
    task ual: :environment do
      p 'save user login to action log'
      UserActionLog.find_each do |record|
        type = record.subject_type
        id = record.subject_id
        subject = type.camelize.constantize.find_by(id: id)
        record.update_attribute(:login, subject.email)
      end
      p 'save employee_cv_id to action log'
      UserActionLog.find_each do |record|
        type = record.object_type
        if type == 'EmployeeCv'
          id = record.object_id
          record.update_attribute(:employee_cv_id, id)
        end
      end
      p 'save order_id to action log'
      UserActionLog.find_each do |record|
        type = record.object_type
        if type == 'Order'
          id = record.object_id
          record.update_attribute(:order_id, id)
        end
      end
    end
  end
end
