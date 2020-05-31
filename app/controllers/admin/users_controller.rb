class Admin::UsersController < Admin::ApplicationController
  before_action :user, only: %i[withdrawal update]

  def index
    @q = User.clients.ransack(params[:q])
    @users = Kaminari.paginate_array(@q.result.decorate).page(params[:page])
  end

  def edit
    user
  end

  def update
    result = Cmd::Admin::User::Update.call(user: user, params: user_params) 
    if result.success?
      redirect_to admin_users_path
    else
      render json: {  validate: true,
                      data: errors_data(result.user) },
                      status: 422
    end
  end

  def withdrawal
    @contractor = @user.profile
    @result = Cmd::Profile::Balance::Withdrawal.call(profile: @contractor, amount: @contractor.balance.amount,
                                                     withdrawal_method_id: @contractor.withdrawal_methods.first.id)
   end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :is_active, :password, :password_confirmation,
                                  profile_attributes: [:id, :phone, :photo, 
                                                       company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone, :inn, 
                                                                            :fax, :email, :acts_on, :director, :kpp, :ogrn]])
  end

  def user
    @user ||= users.find(params[:id])
  end

  def users
    @users ||= User.all
  end
end
