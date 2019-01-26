class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def index
    user_action_log_records if user_signed_in?
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.where(receiver_id: current_user.id)
                                              .order(id: :asc)
                                              .page(params[:page])
                                              .decorate
  end
end
