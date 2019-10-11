class BillTransactionDecorator < ApplicationDecorator
  delegate_all

  def show_invoice?
    description == 'Перевод вознаграждения исполнителю' &&
      transaction_type == 'withdrawal'
  end
end
