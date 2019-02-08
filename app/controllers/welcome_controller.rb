class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :auth_user

  def index
    user_action_log_records if user_signed_in?
  end

  private

  def user_action_log_records
    @user_action_log_records ||= UserActionLog.where('JSON_CONTAINS(receiver_ids, ?) = 1', current_user.id.to_s)
                                              .order(id: :desc)
                                              .page(params[:page])
                                              .decorate
  end
end
