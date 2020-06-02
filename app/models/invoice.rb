class Invoice < ApplicationRecord
  include Persistable
  include AASM

  belongs_to :profile

  validates :seller, :buyer, :goods, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0, less_than: 100_000_000.00 }

  before_create :set_invoice_number
  after_create :send_mail_wait_for_payment, if: -> { profile.notify_mails? }

  scope :customers, -> { joins(:profile).where('profiles.profile_type = ?', 'customer') }
  scope :contractors, -> { joins(:profile).where('profiles.profile_type = ?', 'contractor') }
  scope :prev_invoice, ->(created_at) { where('created_at < ?', created_at).order(id: :desc).limit(1) }

  aasm column: :state do
    state :created, initial: true
    state :paid

    event :pay do
      transitions from: :created, to: :paid
    end
  end

  def set_invoice_number
    ActiveRecord::Base.connection.execute('lock tables invoice_number_seqs write')
    old_value = ActiveRecord::Base
                .connection
                .execute('select invoice_number from invoice_number_seqs limit 1')
                .first.first
    new_value = old_value + 1
    ActiveRecord::Base.connection
                      .execute("update invoice_number_seqs set invoice_number = #{new_value}")
    self.invoice_number = new_value
    ActiveRecord::Base.connection.execute('unlock tables')
  end

  def self.reset_invoice_counter(start_value)
    return if start_value.negative?
    ActiveRecord::Base.connection.execute('lock tables invoice_number_seqs write')
    ActiveRecord::Base.connection
                      .execute("update invoice_number_seqs set invoice_number = #{start_value}")
    ActiveRecord::Base.connection.execute('unlock tables')
  end

  def last_invoice_number
    ActiveRecord::Base.connection.execute('lock tables invoice_number_seqs write')
    last_number = ActiveRecord::Base
        .connection
        .execute('select invoice_number from invoice_number_seqs limit 1')
        .first.first
    ActiveRecord::Base.connection.execute('unlock tables')
    last_number
  end

  def send_mail_wait_for_payment
    SendNotifyMailJob.perform_now(objects: [self], method: 'invoce_wait_payment')
  end
end
