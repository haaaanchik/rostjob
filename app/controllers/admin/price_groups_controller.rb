class Admin::PriceGroupsController < Admin::ApplicationController
  def index
    price_groups
  end

  def new
    @price_group = PriceGroup.new
  end

  def edit
    price_group
  end

  def create
    @price_group = PriceGroup.create(price_group_params)
    if @price_group.errors.messages.any?
      render json: errors_data(@price_group)
    else
      redirect_to admin_price_groups_path
    end
  end

  def update
    price_group.update(price_group_params)
    if price_group.errors.messages.any?
      render json: errors_data(@price_group)
    else
      redirect_to admin_price_groups_path
    end
  end

  def destroy
    price_group.destroy
    if price_group.errors.messages.any?
      render json: errors_data(@price_group)
    else
      redirect_to admin_price_groups_path
    end
  end

  private

  def price_group_params
    params.require(:price_group).permit(:title, :customer_price, :contractor_price)
  end

  def price_group
    @price_group ||= price_groups.find(params[:id])
  end

  def price_groups
    @price_groups ||= PriceGroup.all
  end
end
