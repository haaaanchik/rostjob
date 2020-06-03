# frozen_string_literal: true

class ApprovalListOrActsByProfileQuery
  attr_accessor :scope, :profile, :params

  def initialize(scope, profile, params = {})
    @scope = scope
    @profile = profile
    @params = params
  end

  def call
    if profile_id.blank?
      paginate_array(scope.group_by{ |item| item.profile.decorate  }.to_a)
    else
      paginate_array(scope.where(profile_id: profile_id).group_by{ |item| item.profile.decorate  }.to_a)
    end
  end

  private

  def profile_id
    params[:profile_id]
  end

  def paginate_array(list)
    Kaminari.paginate_array(list).page(params[:page]).per(10)
  end
end
