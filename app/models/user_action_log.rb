class UserActionLog < ApplicationRecord
  validates :receiver_id, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true
  # validates :subject_role, presence: true
  validates :action, presence: true
  validates :object_id, presence: true
  validates :object_type, presence: true
end
