class UsersController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[new create]
  skip_before_action :auth_user, only: %i[new create]

  def new
    @user = User.new
  end

  def edit
    user
  end

  def create
    @user = User.create(user_params)
    errors = @user.errors.messages
    if errors.any?
      render json: errors
    else
      sign_in(@user)
      redirect_to root_path
    end
  end

  def update
    user.update(user_params)
    if user.errors.messages.any?
      render 'edit'
    else
      redirect_to root_path
    end
  end

  def destroy
    user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

  def user
    @user ||= users.find(params[:id])
  end

  def users
    @users ||= User.all
  end
end
