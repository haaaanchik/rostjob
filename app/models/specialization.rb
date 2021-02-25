class Specialization < ApplicationRecord
  include Autocompletable

  has_and_belongs_to_many :positions
  accepts_nested_attributes_for :positions

  has_attached_file :image, styles: { thumb: '300x240' }, default_url: '/img/default_pp.png'
  validates_attachment_content_type :image, content_type: %w[image/jpeg image/gif image/png]

  validates :title, presence: true

  def auto_search_text
    Hash[label: title]
  end
end
