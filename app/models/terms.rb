class Terms
  include ActiveModel::Model

  attr_accessor :accepted

  validates_acceptance_of :accepted

  def initialize(attributes = {})
    attributes = { accepted: false }.merge attributes
    super
  end
end
