class Message < ApplicationRecord
  belongs_to :proposal

  validates :text, presence: true
  validates :sender_id, presence: true

  def receiver
    sender_id != proposal.profile_id ?  proposal.profile_id : proposal.order.profile_id
  end
end
