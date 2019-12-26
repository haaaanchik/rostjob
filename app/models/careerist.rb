class Careerist < ApplicationRecord
  validates :title, presence: true

  scope :active, -> { where(active: true) }

  def initialize(attrs = nil)
    defaults = {
        title: 'Новый запрос на поиск анкет',
        query_params: {
            searchtype: 0,
            searchwhere: 10,
            experience: 10,
            salaryfrom: 100,
            salaryto: 1000,
            agefrom: 18,
            ageto: 40,
            sex: 1,
            time: -1,
            geo: {
                region: [],
                city: []
            }
        },
        active: false
    }

    attrs_with_defaults = attrs ? defaults.merge(attrs) : defaults
    super(attrs_with_defaults)
  end
end
