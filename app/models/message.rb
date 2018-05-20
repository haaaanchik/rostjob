class Message < ApplicationRecord
  belongs_to :proposal

  validates :text, presence: true
end
