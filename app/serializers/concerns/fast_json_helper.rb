# frozen_string_literal: true

module FastJsonHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def serialized_collection(collection, params = {})
      new(collection, { is_collection: true }.merge(params)).serialized_collection
    end

    def serialized_hash(object, params = {})
      new(object, params).serializable_hash.dig(:data).dig(:attributes)
    end
  end

  def serialized_collection
    serializable_hash.dig(:data).map { |record| record[:attributes] }
  end
end
