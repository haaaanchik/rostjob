class Admin::UsersController < Admin::ApplicationController
  def index
    users
  end

  def edit
    user
  end

  def update
    user.update_attribute(:full_name, user_params[:full_name])
    user.update_attribute(:is_active, user_params[:is_active])
    if user.errors.messages.any?
      render json: { validate: true, data: errors_data(user) }
    else
      redirect_to admin_clients_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :is_active)
  end

  def user
    @user ||= users.find(params[:id])
  end

  def users
    @users ||= User.all
  end
end
