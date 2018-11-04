class Admin::AccountStatementsController < Admin::ApplicationController
  def index
    account_statements
  end

  def destroy
    account_statement.destroy
    redirect_to admin_account_statements_path
  end

  def upload
    acc_statements_upload = AccountStatementsUpload.new(account_statements_params)
    if acc_statements_upload.valid?
      result = Cmd::AccountStatements::Parse.call(file: account_statements_params[:file])
      Cmd::AccountStatements::Create.call(documents: result.documents) if result.success?
      redirect_to admin_account_statements_path
    else
      render json: errors_data(acc_statements)
    end
  end

  private

  def account_statements_params
    params[:account_statements_upload]
  end

  def account_statement
    @account_statement ||= account_statements.find(params[:id])
  end

  def account_statements
    @account_statements ||= account.account_statements
  end

  def account
    Company.own_active.accounts.first
  end
end
