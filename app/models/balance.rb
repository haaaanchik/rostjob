class Balance < ApplicationRecord
  has_many :bill_transactions

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def deposit(amount, description)
    ActiveRecord::Base.transaction do
      bt = self.bill_transactions.build(amount: amount, description: description, transaction_type: 'deposit')
      if bt.save
        self.amount += amount.to_i
      else
        promote_errors(bt.errors)
        raise StandardError.new
      end
      save!
    end
    self.amount
  rescue => e
    nil
  end

  def withdrawal(amount, description)
    return if self.amount < amount.to_i
    ActiveRecord::Base.transaction do
      bt = self.bill_transactions.build(amount: amount, description: description, transaction_type: 'withdrawal')
      if bt.save
        self.amount -= amount.to_i
      else
        promote_errors(bt.errors)
        raise StandardError.new
      end
      save!
    end
    self.amount
  rescue
    nil
  end

  private

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def amount=(value)
    write_attribute(:amount, value)
  end
end
