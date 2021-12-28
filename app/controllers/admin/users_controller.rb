class Admin::UsersController < Admin::ApplicationController
  before_action :user, only: %i[withdrawal update change_manager_status]

  def index
    @q = User.clients.ransack(params[:q])
    @users = paginate_array(@q.result.decorate, params[:page])
    respond_to do |format|
      format.html
      format.xlsx do
        @q = User.all.ransack(params[:q])
        @users = @q.result
        render template: 'admin/users/user_email_export'
      end
    end
  end

  def edit
    user
  end

  def update
    result = Cmd::Admin::User::Update.call(user: user, user_params: user_params, balance_amount: params[:amount])
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
    @result = Cmd::Profile::Balance::Withdrawal.call(profile: @contractor,
                                                     invoice: @contractor.invoices.new,
                                                     company: @contractor.withdrawal_methods.first.company,
                                                     reason_text: 'Перевод вознаграждения исполнителю')
  end

  def change_manager_status
    @user.profile.update(manager: params[:active])
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :is_active, :password, :password_confirmation,
                                  profile_attributes: [:id, :phone, :photo,
                                                        company_attributes: [:id, :name, :short_name, :address, :mail_address, :phone, :inn,
                                                          :fax, :email, :acts_on, :director, :kpp, :ogrn, :description, :legal_form,
                                                          accounts_attributes: [:id, :account_number, :corr_account, :bic, :bank, :bank_address, :inn, :kpp]]])
  end

  def user
    @user ||= users.clients.find(params[:id]).decorate
  end

  def users
    @users ||= User.all
  end
end
