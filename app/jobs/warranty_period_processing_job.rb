class WarrantyPeriodProcessingJob < ApplicationJob
  queue_as :processing

  def perform(candidate)
    # TODO: implement warranty period processing
  end
end
