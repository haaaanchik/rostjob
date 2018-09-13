module Persistable
  extend ActiveSupport::Concern

  module ClassMethods
    def persisted
      select(&:persisted?)
    end
  end
end
