namespace :rostjob do
  namespace :fix do
    desc 'Fix contact person'
    task contact_person: :environment do
      p 'фиксим контактное лицо'
      OrderTemplate.find_each do |ot|
        next if ot.contact_person
        ot.update_attribute(:contact_person, name: nil, phone: nil)
      end
      Order.find_each do |o|
        next if o.contact_person
        o.update_attribute(:contact_person, name: nil, phone: nil)
      end
    end
  end
end
