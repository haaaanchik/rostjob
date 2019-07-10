class Message < ApplicationRecord
  belongs_to :ticket

  validates :text, presence: true
  validates :sender_name, presence: true

  def receiver
    sender_id != proposal.profile_id ? proposal.profile_id : proposal.order.profile_id
  end
end
