class FetchResumesJob < ApplicationJob
  queue_as :fetch_resumes

  def perform(service = nil)
    service.kind_of?(Careerist) ? ::Cmd::Careerist::Resumes::CreateAsReady.call(careerist: service) :
                                  ::Cmd::SuperJob::Resumes::CreateAsReady.call(query: service)
  end
end
