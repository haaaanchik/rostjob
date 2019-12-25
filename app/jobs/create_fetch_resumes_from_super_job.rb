class CreateFetchResumesFromSuperJob < ApplicationJob
  queue_as :critical

  def perform
    ::SuperJob::Query.active.find_each(batch_size: 10) do |query|
      ::FetchResumesJob.perform_later(query)
    end
  end
end
