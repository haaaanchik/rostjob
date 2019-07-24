class SuperJob < Oauth
  has_many :towns, dependent: :destroy

  def self.config
    first
  end
end
