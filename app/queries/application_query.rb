# frozen_string_literal: true

class ApplicationQuery
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

  private

  def display_attr_warning(attr)
    Rails.logger.warn("Attribute :#{attr} isn't added to the attributes list")
  end
end
