class Profile::BalancesController < ApplicationController
  def show
    balance
  end

  def deposit
    balance.deposit(balance_params[:value], 'Пополнение счёта')
    if balance.errors.any?
      render 'show'
    else
      redirect_to root_path
    end
  end

  private

  def balance
    @balance ||= current_profile.balance
  end

  def balance_params
    params.require(:balance).permit(:value)
  end
end
