class Admin::ClientsController < Admin::ApplicationController
  CLIENT_TYPES = %w[customer contractor].freeze

  def index
    @q = if client_type.include?('customer')
           User.customers.ransack(params[:q])
         elsif client_type.include?('contractor')
           User.contractors.ransack(params[:q])
         else
           User.clients.ransack(params[:q])
         end

    @clients = @q.result.decorate
    @client_type = client_type
  end

  def withdrawal
    @contractor = user.profile
    @result = Cmd::Profile::Balance::Withdrawal.call(profile: @contractor, amount: @contractor.balance.amount,
                                                     withdrawal_method_id: @contractor.withdrawal_methods.first.id)
  end

  private

  def client_type
    CLIENT_TYPES.include?(params.try(:[], :clients_type)) ? params[:clients_type] : 'all'
  end

  def user
    User.find(params[:id])
  end
end
