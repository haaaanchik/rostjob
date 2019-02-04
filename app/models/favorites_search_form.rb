class FavoritesSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :query

  def initialize(params)
    @query = params ? params[:query] : ''
  end

  def persisted?
    false
  end

  def submit
    if query.empty?
      Order.published.decorate
    else
      Order.published.send(:by_query, query).decorate
    end
  end
end
