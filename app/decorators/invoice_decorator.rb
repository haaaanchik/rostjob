class InvoiceDecorator < ApplicationDecorator
  delegate_all

  # TODO: refactoring code
  def customer_pdf_link
    return tinkoff_pdf_url if tinkoff_pdf_url.present?

    h.profile_invoice_path(object, format: :pdf)
  end

  def link_for_check_pay
    return if paid?

    disabled = checking_pay? ? ' disabled' : ''
    klass = 'btn btn-sm btn-default float-right' + disabled
    h.content_tag(:a,
                  href: h.check_invoice_tinkoff_profile_invoice_path(object),
                  class: klass) { 'проверить выписку' }
  end
end
