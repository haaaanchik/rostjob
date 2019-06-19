class Admin::DashboardsController < Admin::ApplicationController
  def show
    metrics
    paginated_employee_cvs
  end

  private

  def metrics
    @metrics ||= [
      created_employee_cvs
    ]
  end

  def paginated_employee_cvs
    @paginated_employee_cvs ||= employee_cvs.page(params[:page])
  end

  def employee_cvs
    @employee_cvs = EmployeeCv.all
  end

  def created_employee_cvs
    OpenStruct.new(
      title: 'Создано анкет',
      today: EmployeeCv.created_today.count,
      two_days: EmployeeCv.created_last_2days.count,
      three_days: EmployeeCv.created_last_3days.count,
      seven_days: EmployeeCv.created_last_7days.count,
      fourteen_days: EmployeeCv.created_last_14days.count,
      one_month: EmployeeCv.created_last_1month.count,
      total: EmployeeCv.count
    )
  end
end
