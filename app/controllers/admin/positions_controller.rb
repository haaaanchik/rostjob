class Admin::PositionsController < Admin::ApplicationController
  before_action :price_groups, only: %i[index new edit]

  def index
    positions
  end

  def new
    @position = Position.new
  end

  def edit
    position
  end

  def create
    @position = Position.create(position_params)
    if @position.errors.messages.any?
      render json: errors_data(@position)
    else
      redirect_to admin_positions_path
    end
  end

  def update
    position.update(position_params)
    if position.errors.messages.any?
      render json: errors_data(@position)
    else
      redirect_to admin_positions_path
    end
  end

  def destroy
    position.destroy
    redirect_to admin_positions_path
  end

  private

  def price_groups
    @price_groups = PriceGroup.all
  end

  def position_params
    params.require(:position).permit(:title, :duties, :price_group_id)
  end

  def position
    @position ||= positions.find(params[:id])
  end

  def positions
    @positions ||= Position.order(title: :asc)
  end
end
