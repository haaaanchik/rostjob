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
    result = Cmd::SuperJob::Query::Create.call(params: superjob_query_params)
    if result.success?
      redirect_to admin_superjob_queries_path
    else
      render json: { validate: true, data: errors_data(result.query) }, status: 422
    end
  end

  def update
    result = Cmd::SuperJob::Query::Update.call(query: query, params: superjob_query_params)
    if result.success?
      redirect_to admin_superjob_queries_path
    else
      render json: { validate: true, data: errors_data(result.query) }, status: 422
    end
  end

  def destroy
    query.destroy
    redirect_to admin_superjob_queries_path
  end

  def copy
    result = Cmd::SuperJob::Query::Copy.call(query: query)
    redirect_to admin_superjob_queries_path result.success?
  end

  def activate
    result = Cmd::SuperJob::Query::Activate.call(query: query)
    redirect_to admin_superjob_queries_path result.success?
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
