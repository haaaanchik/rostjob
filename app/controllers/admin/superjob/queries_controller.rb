class Admin::Superjob::QueriesController < Admin::Superjob::ApplicationController
  def index
    paginated_queries
  end

  def new
    @query = SuperJob::Query.new
  end

  def edit
    query
  end

  def create
    result = Cmd::Service::Create.call(params:        superjob_query_params,
                                       service_klass: ::SuperJob::Query)
    if result.success?
      redirect_to admin_superjob_queries_path
    else
      render json: { validate: true, data: errors_data(result.service) }, status: 422
    end
  end

  def update
    result = Cmd::Service::Update.call(service: query, params: superjob_query_params)
    if result.success?
      redirect_to admin_superjob_queries_path
    else
      render json: { validate: true, data: errors_data(result.service) }, status: 422
    end
  end

  def destroy
    query.destroy
    redirect_to admin_superjob_queries_path
  end

  def copy
    result = Cmd::Service::Copy.call(service:        query,
                                     service_klass:  ::SuperJob::Query)
    redirect_to admin_superjob_queries_path result.success?
  end

  def activate
    Cmd::Service::Activate.call(service: query)
  end

  def deactivate
    Cmd::Service::Deactivate.call(service: query)
  end

  def activate_all
    Cmd::Service::ActivateAll.call(service: ::SuperJob::Query)
  end

  def deactivate_all
    Cmd::Service::DeactivateAll.call(service: ::SuperJob::Query)
  end

  private

  def superjob_query_params
    params.require(:super_job_query).permit(:title, :active, query_params: {})
  end

  def query
    @query ||= queries.find(params[:id])
  end

  def paginated_queries
    @paginated_queries ||= queries.page(params[:page])
  end

  def queries
    @queries ||= superjob_config.queries.order(active: :desc)
  end
end
