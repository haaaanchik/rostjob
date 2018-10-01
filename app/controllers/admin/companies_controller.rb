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
    @company = Company.build(company_params.merge(own_company: true))
    @company.save(context: :company)
    if @company.errors.messages.any?
      render json: errors_data(@company)
    else
      redirect_to admin_companies_path
    end
  end

  def update
    company.assign_attributes(company_params)
    company.save(context: :company)
    if company.errors.messages.any?
      render json: errors_data(@company)
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
    @companies ||= Company.own.order(name: :asc)
  end
end
