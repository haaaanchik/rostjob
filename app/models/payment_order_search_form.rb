class PaymentOrderSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :date_from, :date_to

  validates :date_from, :date_to, presence: true

  def initialize(params)
    @date_from = filter_date_from(params)
    @date_to = filter_date_to(params)
    date_tmp = @date_from
    return if @date_from <= @date_to
    @date_from = @date_to
    @date_to = date_tmp
  end

  def persisted?
    false
  end

  def submit
    if valid?
      payment_orders.where(created_at: date_from..date_to)
    else
      payment_orders
    end
  end

  def payment_orders
    own_company.payment_orders
  end

  def own_company
    Company.own_active
  end

  def filter_date_from(params)
    return Time.current.beginning_of_day unless params
    date_from = params[:date_from]
    return Time.current.beginning_of_day if date_from.nil? || date_from.empty?
    Time.zone.parse(date_from).beginning_of_day
  end

  def filter_date_to(params)
    return Time.current.end_of_day unless params
    date_to = params[:date_to]
    return Time.current.end_of_day if date_to.nil? || date_to.empty?
    Time.zone.parse(date_to).end_of_day
  end
end
