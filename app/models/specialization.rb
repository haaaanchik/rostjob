class Specialization < ApplicationRecord
  include Autocompletable

  has_and_belongs_to_many :positions
  accepts_nested_attributes_for :positions

  validates :title, presence: true

  def auto_search_text
    Hash[label: title]
  end
end
