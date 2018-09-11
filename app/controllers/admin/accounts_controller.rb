class Admin::AccountsController < Admin::ApplicationController
  def index
    accounts
  end

  def new
    @account = Account.new
  end

  def edit
    account
  end

  def create
    @account = Account.create(account_params)
    if @account.errors.messages.any?
      render 'new'
    else
      redirect_to admin_accounts_path
    end
  end

  def update
    account.update(account_params)
    if account.errors.messages.any?
      render 'edit'
    else
      redirect_to admin_accounts_path
    end
  end

  def destroy
    account.destroy
    redirect_to admin_accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:account_number, :corr_account, :bic, :bank)
  end

  def account
    @account ||= accounts.find(params[:id])
  end

  def accounts
    @accounts ||= Account.order(title: :asc)
  end
end
