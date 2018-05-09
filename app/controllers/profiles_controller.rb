class ProfilesController < ApplicationController
  def show
    profile
  end

  def edit
  end

  def update
    profile.assign_attributes(profile_params)
    result = profile.save
    if result
      profile.fill!
      redirect_to root_path
    else
      render 'show'
    end
  end

  private

  def profile
    @profile ||= current_profile
  end

  def profile_params
    params.require(:profile).permit(:contact_person, :phone, :company_name, :email, :profile_type)
  end
end
