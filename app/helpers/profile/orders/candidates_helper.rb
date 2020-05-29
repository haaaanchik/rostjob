module Profile::Orders::CandidatesHelper
  def act_user_image(active_contractor)
    img_url = active_contractor.blank? ? '/img/new/no-avatar.png' : active_contractor.image_url

    content_tag(:img, nil, src: img_url)
  end

  def act_user_full_name(active_contractor)
    return 'Рекрутер не найден' if active_contractor.blank?

    active_contractor.user.full_name
  end

  def act_user_display_rating(active_contractor)
    return 'Нет данных' if active_contractor.blank?

    active_contractor.display_rating
  end

  def act_user_display_deal_counter(active_contractor)
    return 'Нет данных' if active_contractor.blank?

    active_contractor.display_deal_counter
  end
end
