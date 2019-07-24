class FetchResumesJob < ApplicationJob
  queue_as :critical

  def perform
    Cmd::SuperJob::Resumes::CreateAsReady.call
  end
end
