class Admin::DashboardsController < Admin::ApplicationController
  def show
    metrics
  end

  private

  def metrics
    @metrics ||= [
      created_employee_cvs
    ]
  end

  def created_employee_cvs
    OpenStruct.new(
      title: 'Создано анкет',
      today: ProposalEmployee.created_today.count,
      two_days: ProposalEmployee.created_last_2days.count,
      three_days: ProposalEmployee.created_last_3days.count,
      seven_days: ProposalEmployee.created_last_7days.count,
      fourteen_days: ProposalEmployee.created_last_14days.count,
      one_month: ProposalEmployee.created_last_1month.count,
      total: ProposalEmployee.count
    )
  end
end
