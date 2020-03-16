module UserActionLogRepository
  extend ActiveSupport::Concern

  included do
    scope :json_contain_receiver_ids, -> (current_user){ where('JSON_CONTAINS(receiver_ids, ?) = 1', current_user.id.to_s)}
  end
end