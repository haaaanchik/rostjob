class Api::V1::ApplicationController < BaseController
  skip_before_action :verify_authenticity_token

  protected

  def respond_success(data = [], status = 200)
    render json: { status: :ok, data: wrap_to_array(data) }, status: status
  end

  def respond_error(data = [], status = 422)
    render json: { status: :error, data: wrap_to_array(data) }, status: status
  end

  def wrap_to_array(data)
    return data if data.is_a? Array

    [data]
  end
end
