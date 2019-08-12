class SuperJob::Query < ApplicationRecord
  belongs_to :config

  scope :active, -> { where(active: true) }

  validates :title, presence: true

  def initialize(attrs = nil)
    defaults = {
      title: 'Новый запрос на поиск анкет',
      query_params: {
        period: 7,
        keywords: [
          {
            srws: 7,
            skwc: 'or',
            keys: ''
          }
        ],
        exclude_words: '',
        payment_from: nil,
        payment_to: nil,
        catalogues: [],
        experience_from: nil,
        experience_to: nil,
        gender: 0,
        portfolio: 0,
        has_photo: 0,
        o: [],
        t: []
      },
      active: false
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end
end
