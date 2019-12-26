class CreateFetchResumesFromCareeristJob < ApplicationJob
  queue_as :critical

  def perform
    ::Careerist.active.find_each(batch_size: 30) do |careerist|
      ::FetchResumesJob.perform_later(careerist)
    end
  end
end
