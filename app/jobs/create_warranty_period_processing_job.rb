class CreateWarrantyPeriodProcessingJob < ApplicationJob
  queue_as :critical

  def perform
    EmployeeCv.hired.find_each(batch_size: 50) do |candidate|
      warranty_period = candidate.proposal.order.warranty_period
      hiring_date = candidate.hiring_date
      if Time.now >= hiring_date + warranty_period
        ::WarrantyPeriodProcessingJob.perform_later(candidate)
      end
    end
  end
end
