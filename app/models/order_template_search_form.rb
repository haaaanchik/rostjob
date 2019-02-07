class OrderTemplateSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :query

  def initialize(attr)
    @current_profile = attr[:profile]
    @query = attr[:params] ? attr[:params][:query] : ''
  end

  def persisted?
    false
  end

  def submit
    if @query.empty?
      @current_profile.order_templates.order(id: :desc)
    else
      @current_profile.order_templates.send(:by_query, @query).order(id: :desc)
    end
  end
end
