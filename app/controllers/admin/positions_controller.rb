class Admin::PositionsController < Admin::ApplicationController
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
      render 'new'
    else
      redirect_to admin_positions_path
    end
  end

  def update
    position.update(position_params)
    if position.errors.messages.any?
      render 'edit'
    else
      redirect_to admin_positions_path
    end
  end

  def destroy
    position.destroy
    redirect_to admin_positions_path
  end

  private

  def position_params
    params.require(:position).permit(:title, :duties)
  end

  def position
    @position ||= positions.find(params[:id])
  end

  def positions
    @positions ||= Position.order(title: :asc)
  end
end
