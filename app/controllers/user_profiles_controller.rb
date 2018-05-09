class UserProfilesController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
    profile
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def profile
    # @profile ||= current_user.profile
  end
end
