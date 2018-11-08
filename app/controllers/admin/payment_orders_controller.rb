class Admin::PaymentOrdersController < Admin::ApplicationController
  before_action :search_payment_orders

  def index; end

  def download
    result = Cmd::PaymentOrder::ConvertToOneC.call(payment_orders: @payment_orders)
    send_file result.file if result.success?
  end

  private

  def search_payment_orders
    @payment_order_search_form = PaymentOrderSearchForm.new(payment_order_search_form_params)
    @payment_orders = @payment_order_search_form.submit
  end

  def payment_order_search_form_params
    params.permit(payment_order_search_form: %i[date_from date_to])[:payment_order_search_form]
  end
end
