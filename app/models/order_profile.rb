class OrderProfile < ApplicationRecord
  belongs_to :order
  belongs_to :profile
end
