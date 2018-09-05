class MessageToSupport < ApplicationRecord
  validates :sender_name, presence: true
  validates :email_address, presence: true, email: true
  validates :text, presence: true
end
