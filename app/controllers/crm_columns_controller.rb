# frozen_string_literal: true

class CrmColumnsController < ApplicationController
  def create
    crm_column = CrmColumn.new
    result = Cmd::CrmColumns::Save.call(user: current_user,
                                        params: params[:crm_column],
                                        crm_column: crm_column)

    if result.success?
      render json: { id: result.crm_column.id }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def update
    crm_column = CrmColumn.find(params[:id])
    result = Cmd::CrmColumns::Save.call(user: crm_column.user,
                                        params: params[:crm_column],
                                        crm_column: crm_column)

    if result.success?
      render json: { message: 'success' }
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Cmd::CrmColumns::Destroy.call(user: current_user,
                                           column_id: params[:id])

    render json: :no_content, status: result.success? ? 200 : 422
  end

  def add_employee_cv
    result = Cmd::CrmColumns::EmployeeCv::Create.call(user: current_user,
                                                      crm_column_id: params[:crm_column_id],
                                                      employee_cv_id: employee_cv_id)

    render json: :no_content, status: result.success? ? 200 : 422
  end

  def destroy_employee_cv
    result = Cmd::CrmColumns::EmployeeCv::Destroy.call(current_profile: current_profile,
                                                       employee_cv_id: employee_cv_id)

    render json: :no_content, status: result.success? ? 200 : 422
  end

  def update_employee_cv
    result = Cmd::CrmColumns::EmployeeCv::Update.call(user: current_user,
                                                      crm_column_id: params[:crm_column_id],
                                                      employee_cv_id: employee_cv_id)

    render json: :no_content, status: result.success? ? 200 : 422
  end

  private

  def employee_cv_id
    params[:crm_column][:employee_cv_id].to_i
  end
end
