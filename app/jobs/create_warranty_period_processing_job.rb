class CreateWarrantyPeriodProcessingJob < ApplicationJob
  queue_as :critical

  def perform
    EmployeeCv.hired.find_each(batch_size: 50) do |candidate|
      ::WarrantyPeriodProcessingJob.perform_later(candidate) if Time.now > candidate.warranty_date
    end
  end
end
