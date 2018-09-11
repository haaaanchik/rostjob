class Admin::CompaniesController < Admin::ApplicationController
  def index
    companies
  end

  def new
    @company = Company.new
    @company.accounts.build
  end

  def edit
    company
  end

  def create
    @company = Company.create(company_params)
    if @company.errors.messages.any?
      render 'new'
    else
      redirect_to admin_companies_path
    end
  end

  def update
    company.update(company_params)
    if company.errors.messages.any?
      render 'edit'
    else
      redirect_to admin_companies_path
    end
  end

  def destroy
    company.destroy
    redirect_to admin_companies_path
  end

  private

  def company_params
    params.require(:company)
          .permit(:name, :short_name, :address, :mail_address, :phone, :fax,
                  :email, :inn, :kpp, :ogrn, :director, :acts_on,
                  accounts_attributes: %i[id account_number corr_account bic bank bank_address])
  end

  def company
    @company ||= companies.find(params[:id])
  end

  def companies
    @companies ||= Company.order(name: :asc)
  end
end
