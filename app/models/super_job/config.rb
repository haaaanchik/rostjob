class SuperJob::Config < ApplicationRecord
  has_many :queries, dependent: :destroy
  has_one :active_query, -> { where active: true }, class_name: 'SuperJob::Query',
                                                    inverse_of: :config

  def self.config
    first
  end
end
