# frozen_string_literal: true

class Admin::InvoicePolicy < Admin::StafferPolicy
  def invoices_by_bank?
    super_admin?
  end
end
