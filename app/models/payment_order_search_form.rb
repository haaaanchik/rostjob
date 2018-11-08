class PaymentOrderSearchForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :date_from, :date_to

  validates :date_from, :date_to, presence: true

  def initialize(params)
    if params
      @date_from = Time.parse(params.fetch(:date_from, Time.now.beginning_of_day.to_s))
      @date_to = Time.parse(params.fetch(:date_to, Time.now.end_of_day.to_s))
      date_tmp = @date_from
      if @date_from > @date_to
        @date_from = @date_to
        @date_to = date_tmp
      end
    else
      @date_from = Time.now.beginning_of_day
      @date_to = Time.now.end_of_day
    end
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
end
