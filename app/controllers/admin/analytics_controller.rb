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

  private

  def date_interval
    from = Date.parse(params[:from]) if params[:from]
    to = Date.parse(params[:to]) if params[:to]
    from..to
  end

  def orders
    @orders ||= Order.where(created_at: date_interval)
  end
end
