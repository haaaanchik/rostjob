class Api::V1::FreeManagersController < Api::V1::ApplicationController
  def show
    result = Cmd::FreeManager::Process.call(input_params: free_manager_params)
    if result.success?
      respond_success(result.manager || [])
    else
      respond_error(result.message, result.code)
    end
  end

  private

  def free_manager_params
    params.slice(:api_token)
  end
end
