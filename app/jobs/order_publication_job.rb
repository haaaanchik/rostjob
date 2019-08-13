class OrderPublicationJob < ApplicationJob
  queue_as :critical

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    profile = invoice.profile
    orders = profile.orders.waiting_for_payment
    orders.each(&:to_moderation)
  end
end
