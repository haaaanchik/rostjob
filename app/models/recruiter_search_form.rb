class RecruiterSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :query

  def initialize(params)
    if params
      @query = params[:query]
    else
      @query = ''
    end
  end

  def persisted?
    false
  end

  def submit
    unless query.empty?
      Profile.contractors.by_query(query)
    else
      Profile.contractors.limit(20)
    end
  end
end
