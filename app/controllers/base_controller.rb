class BaseController < ActionController::Base
  include WordsHelper
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def paginate_array(lists, page)
    Kaminari.paginate_array(lists).page(page)
  end

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

  private

  def record_not_found
    url = request.url.include?('admin') ? admin_root_path : root_path

    redirect_back(fallback_location: url)
    flash[:alert] = 'Запись не существует или не была найдена'
  end
end
