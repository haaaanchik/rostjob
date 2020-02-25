module OrderTemplatesHelper

  def first_step_save_button
    content_tag(:button, type: 'submit') do
      concat(content_tag(:p, 'Далее'))
      concat(content_tag(:img, nil, src: asset_path('svg/thin_arrow_right.svg'), id: 'btn-next'))
    end
  end
end
