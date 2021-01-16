class InvoiceDecorator < ApplicationDecorator
  delegate_all

  # TODO: refactoring code
  def display_customer_pdf_link
    return if tinkoff_pdf_url.blank?

    h.link_to(tinkoff_pdf_url, target: '_blank',
              data: { toggle: 'tooltip',
                      placement: 'top',
                      title: 'Скачать в формате PDF' },
              class: 'ml-1 file-pdf') do
      h.content_tag(:i, class: 'far fa-file-pdf fa-2x') {}
    end
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
