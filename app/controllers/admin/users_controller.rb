class Admin::UsersController < Admin::ApplicationController
  def index
    users
  end

  def edit
    user
  end

  def update
    user.update(user_params)
    if user.errors.messages.any?
      render json: { validate: true, data: errors_data(user) }
    else
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :login, :password, :password_confirmation, :is_active)
  end

  def user
    @user ||= users.find(params[:id])
  end

  def users
    @users ||= User.all
  end
end
