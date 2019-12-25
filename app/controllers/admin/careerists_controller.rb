class Admin::CareeristsController < Admin::ApplicationController
  before_action :set_careerist, except: %i[index new create activate_all deactivate_all run_job]

  def index
    @careerists = Careerist.page(params[:page])
  end

  def new
    @careerist = Careerist.new
  end

  def edit; end

  def create
    result = Cmd::Service::Create.call(params:        careerist_params,
                                       service_klass: Careerist)
    if result.success?
      redirect_to admin_careerists_path
    else
      render json: { validate: true, data: errors_data(result.service) }, status: 422
    end
  end

  def update
    result = Cmd::Service::Update.call(service: @careerist,
                                       params:  careerist_params)
    if result.success?
      redirect_to admin_careerists_path
    else
      render json: { validate: true, data: errors_data(result.service) }, status: 422
    end
  end

  def destroy
    @careerist.destroy
    redirect_to admin_careerists_path
  end

  def copy
    result = Cmd::Service::Copy.call(service:        @careerist,
                                     service_klass:  ::SuperJob::Query)
    redirect_to admin_careerists_path result.success?
  end

  def activate
    Cmd::Service::Activate.call(service: @careerist)
  end

  def deactivate
    Cmd::Service::Deactivate.call(service: @careerist)
  end

  def activate_all
    Cmd::Service::ActivateAll.call(service: Careerist)
  end

  def deactivate_all
    Cmd::Service::DeactivateAll.call(service: Careerist)
  end

  def run_job
    CreateFetchResumesFromCareeristJob.perform_now
  end

  private

  def careerist_params
    params.require(:careerist).permit(:title, :active, query_params: {})
  end

  def set_careerist
    @careerist = Careerist.find(params[:id])
  end
end
