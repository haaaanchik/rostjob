class Invoice < ApplicationRecord
  include Persistable
  include AASM

  belongs_to :profile

  validates :seller, :buyer, :amount, :goods, presence: true

  before_save :set_invoice_number

  aasm column: :state do
    state :created, initial: true
    state :paid
    state :deleted

    event :pay do
      transitions from: :created, to: :paid
    end

    event :delete_invoice do
      transitions from: :created, to: :deleted
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
end