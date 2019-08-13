class FetchResumesJob < ApplicationJob
  queue_as :fetch_resumes

  def perform(query = nil)
    ::Cmd::SuperJob::Resumes::CreateAsReady.call(query: query)
  end
end
