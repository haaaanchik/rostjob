class ClientsSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :query
  attr_accessor :client_type

  def initialize(params)
    @query = params ? params[:query] : ''
    @client_type = params ? params[:type] : 'customer'
  end

  def persisted?
    false
  end

  def submit
    if client_type.include?('customer')
      customers
    elsif client_type.include? 'contractor'
      contractors
    end
  end

  private

  def customers
    User.includes(:profile).decorate.select { |u| u.profile.customer? }
  end

  def contractors
    User.includes(:profile).decorate.select { |u| u.profile.contractor? }
  end
end
