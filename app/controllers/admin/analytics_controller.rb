class Admin::AnalyticsController < Admin::ApplicationController
  skip_before_action :set_authorize, only: %i[orders_info]

  def export_to_excel
    orders
    respond_to do |format|
      format.xlsx do
        response.headers[
          'Content-Disposition'
        ] = "attachment; filename='items.xlsx'"
      end
      format.html { render :export_to_excel }
    end
  end

  def user_action_log
    @q = UserActionLog.ransack(params[:q])
    @user_action_log_records = @q.result.includes(:subject).page(params[:page])
                                        .per(12).decorate
  end

  def orders_info
    authorize [:admin, :analytic]

    @orders = paginate_array(find_orders, params[:page])

    respond_to do |format|
      format.html
      format.pdf { render pdf_settings }
    end
  end

  private

  def date_interval
    from = Date.parse(params[:from]) if params[:from]
    to = Date.parse(params[:to]) if params[:to]
    from..to
  end

  def orders
    @orders ||= Order.where(created_at: date_interval)
  end

  def find_orders
    @q = Order.for_analytics.ransack(params[:q])
    @orders = @q.result.includes(:user, :proposal_employees).where.not(state: :draft).decorate
  end

  def pdf_settings
    {
      pdf: 'analytics_orders',
      template: 'export_pdf/_analytics_orders.html',
      orientation: 'Landscape',
      page_size: 'A4',
      locals: { orders: find_orders },
      dpi: 300,
      encoding: 'utf-8'
    }
  end
end
