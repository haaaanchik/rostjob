namespace :best_hr do
  namespace :seed do
    desc 'Copy receiver_id to receiver_ids'
    task fix_receiver_ids: :environment do
      p 'Copy receiver_id to receiver_ids'
      UserActionLog.find_each do |record|
        record.receiver_ids = [record.receiver_id]
        record.save
      end
    end
  end
end
