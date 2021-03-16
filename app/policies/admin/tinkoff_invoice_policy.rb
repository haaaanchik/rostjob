# frozen_string_literal: true

class  Admin::TinkoffInvoicePolicy < Struct.new(:user, :admin, :tinkoff_invoice)

  def show?
    user.super_admin?
  end
end
