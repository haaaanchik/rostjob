# frozen_string_literal: true

class Admin::ProposalEmployeeInvoicesController < Admin::ApplicationController

  before_action :set_proposal_employee, only: %i[show]
  def index
  @q = ProposalEmployee.paid
                       .order(payment_date: :desc)
                       .includes(:employee_cv, order: [:position, profile: :user])
                       .page(params[:page]).ransack(params[:q])
  @proposal_employees = @q.result
end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ProposalEmployeeInvoicesPdf.new(@proposal_employee, view_context)
        send_data pdf.render, filename: "Счёт #{set_proposal_employee.employee_cv.name} от #{l(set_proposal_employee.created_at, format: :short)}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
  end

  private

  def set_proposal_employee
    @proposal_employee = ProposalEmployee.find(params[:id])
  end
end
