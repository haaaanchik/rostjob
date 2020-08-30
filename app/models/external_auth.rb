class ExternalAuth < ApplicationRecord
  validates :provider, presence: true

  class << self
    def zarplata
      find_or_create_by(provider: 'zarplata')
    end
  end
end
