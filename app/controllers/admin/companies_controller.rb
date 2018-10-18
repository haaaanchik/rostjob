class Admin::CompaniesController < Admin::ApplicationController
  def index
    companies
  end

  def new
    @company = Company.new
    @company.accounts.build
    @company.build_tax_office
  end

  def edit
    company
  end

  def create
    @company = Company.new(company_params.merge(own_company: true))
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
                  accounts_attributes: %i[id account_number corr_account bic bank bank_address],
                  tax_office_attributes: %i[id code name name_short payment_name oktmo inn kpp
                                            bank_name bank_bic bank_account])
  end

  def company
    @company ||= companies.find(params[:id])
  end

  def companies
    @companies ||= Company.own.order(name: :asc)
  end
end
