class Invite < ApplicationRecord
  belongs_to :order
  belongs_to :executor, class_name: 'Profile'
end
