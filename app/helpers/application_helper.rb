module ApplicationHelper
  def body_data_page
    (params[:controller].split('/') << action_name).map(&:camelize).join
  end

  def body_controller
    params[:controller].split('/').push(params[:action]).join('_')
  end

  def landing_main_path
    request.path.scan(/^\/\w+/).first
  end

  def landing_another_path(name)
    landing_main_path << name
  end

  def landing_registration_path
    return new_customer_path if landing_main_path == '/industrial'

    new_contractor_path
  end

  def question_help(title)
    content_tag :span, '', class: 'question-help', 'data-toggle': 'tooltip', title: title
  end

  def render_escape(name, locals, additional = {})
    pt_hash = { partial: name, locals: locals }.merge(additional)
    j render(pt_hash)
  end

  def date_rus(date)
    return '' unless date
    # date.to_rus
    l date, format: :short
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

  def st_submit_class(tag = 'success')
    "btn btn-#{tag} btn-sm"
  end
end
