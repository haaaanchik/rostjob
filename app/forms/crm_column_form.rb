# frozen_string_literal: true

class CrmColumnForm < Reform::Form
  properties :name, :user_id

  validates :name, :user_id, presence: true
end
