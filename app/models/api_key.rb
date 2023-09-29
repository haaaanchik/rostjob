# frozen_string_literal: true

class ApiKey < ApplicationRecord
  include AASM

  before_save :generate_token, if: :name_changed?

  validates :name, presence: true

  aasm column: :state do
    state :inactive, initial: true
    state :active
  end

  def generate_token
    self.token = name.downcase + '_' + SecureRandom.urlsafe_base64(60)
  end
end
