module ApplicationHelper

  def render_escape(name, locals, additional = {})
    pt_hash = {partial: name, locals: locals}.merge(additional)
    escape_javascript render(pt_hash)
  end

  def date_rus(date)
    return '' unless date
    date.to_rus
  end

  def st_input_class
    'form-control input-sm m-0'
  end

  def inviz_input_class
    'form-control input-sm m-0 border-0'
  end

  def st_select_class
    'custom-select d-block btn-sm ml-1'
  end

  def inviz_select_class
    'custom-select d-block custom-select-sm m-0 border-0'
  end

  def st_input_form_class(col = 4)
    "md-form col-#{col} m-2"
  end

  def require_field
    content_tag(:small, '*Обязательное поле', class: "form-text text-muted text-warning")
  end

  def st_submit_class(tag = 'success')
    "btn btn-#{tag} btn-sm"
  end

end
