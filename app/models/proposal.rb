class Proposal < ApplicationRecord
  belongs_to :order
  belongs_to :profile
  has_many :messages
  has_many :employee_cvs
end
