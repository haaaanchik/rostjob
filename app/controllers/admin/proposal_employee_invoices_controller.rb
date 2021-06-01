# frozen_string_literal: true

class Admin::ProposalEmployeeInvoicesController < Admin::ApplicationController

  before_action :set_proposal_employee, only: %i[show]
  def index
    @proposal_employees ||= ProposalEmployee.paid.page(params[:page])
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
