class Api::V1::CandidatesController < Api::V1::ApplicationController
  def new
    result = Cmd::Api::BotCallback::Process.call(input_params: candidate_params)
    if result.success?
      respond_success
    else
      respond_error(result.message, result.code)
    end
  end

  private

  def candidate_params
    params.slice(:api_token, :guid, :name, :phone)
  end
end
