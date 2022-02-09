# frozen_string_literal: true

class ApplicationService
  attr_accessor :result

  class << self
    def call(params = {})
      new(params).call
    end
  end

  def initialize(params = {})
    params.each do |attr, value|
      display_attr_warning(attr) && next unless respond_to?("#{attr}=")

      public_send("#{attr}=", value)
    end
  end

  def call
    process

    self
  end

  def process; end

  private

  def display_attr_warning(attr)
    Rails.logger.warn("#{self.class.name}: attribute :#{attr} isn't added to the attributes list")
  end
end
