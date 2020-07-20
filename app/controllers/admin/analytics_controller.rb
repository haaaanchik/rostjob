class Admin::AnalyticsController < Admin::ApplicationController

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
    @q = Order.for_analytics.ransack(params[:q])
    result = params[:q] && params[:q][:state_eq] ? @q.result : @q.result.where(state: :published)
    @orders = result.includes(:user).where.not(state: :draft).decorate
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

  def set_authorize
    authorize [:admin, :analytic]
  end
end
