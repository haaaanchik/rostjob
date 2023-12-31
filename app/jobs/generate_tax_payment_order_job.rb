class GenerateTaxPaymentOrderJob < ApplicationJob
  queue_as :payment_orders

  def perform
    payer = Company.own_active
    kbk = '18210102010011000110'
    amount = TaxCalculation.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)
                           .sum(:tax_amount)
    Cmd::PaymentOrder::Tax::Create.call(payer: payer, kbk: kbk, amount: amount)
  end
end
