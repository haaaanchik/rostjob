class Admin::Superjob::ApplicationController < Admin::ApplicationController
  private

  def superjob_config
    @superjob_config ||= SuperJob::Config.config
  end
end
