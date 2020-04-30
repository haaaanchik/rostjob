class UserActionLog < ApplicationRecord
  include UserActionLogRepository
  default_scope { order(created_at: :desc) }

  validates :receiver_ids, presence: true
  validates :subject_id, presence: true
  validates :subject_type, presence: true
  # validates :subject_role, presence: true
  validates :action, presence: true
  validates :object_id, presence: true
  validates :object_type, presence: true

  ransack_alias :main_logs_fields, :login_or_action_or_order_id_or_employee_cv_id

  def initialize(attrs = nil)
    defaults = {
      receiver_ids: []
    }
    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end

end
