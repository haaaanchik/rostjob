class ProductionSiteDecorator < ObjDecorator
  delegate_all

  def insert_klass(p_site)
    object.id == p_site ? 'clickable current_production_sites' : 'clickable'
  end

  def created_at_str
    created_at.strftime('%d.%m.%Y')
  end
end