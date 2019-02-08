class UserActionLog < ApplicationRecord
  validates :receiver_ids, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true
  # validates :subject_role, presence: true
  validates :action, presence: true
  validates :object_id, presence: true
  validates :object_type, presence: true

  def initialize(attrs = nil)
    defaults = {
      receiver_ids: []
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

end
