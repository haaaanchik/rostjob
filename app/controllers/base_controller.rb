class BaseController < ActionController::Base
  include WordsHelper

  def errors_data(obj)
    errors_data = {}
    prefix = obj.class.to_s.underscore
    errors = obj.errors.messages
    errs = errors.map do |err|
      [err.first.to_s, err.last.first]
    end
    errs.map do |err|
      err_keys = err.first.split('.')
      field_name = "_#{err_keys.pop}"
      err_keys.map! do |ek|
        if plural?(ek)
          "#{ek}_attributes_0"
        else
          "#{ek}_attributes"
        end
      end
      err_path = err_keys.any? ? "_#{err_keys.join('_')}" : ''
      errors_data["#{prefix}#{err_path}#{field_name}"] = err.last
    end
    errors_data
  end
end
