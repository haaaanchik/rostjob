class Users::RegistrationsController < Devise::RegistrationsController
  def create
    result = ::UserProfile::Create.call(profile_params: profile_params, context: :default_registration)
    if result.success?
      build_resource(sign_up_params.merge(profile_id: result.profile.id, email: result.profile.email))
      resource.save
      if resource.persisted?
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else

    end
  end

  protected

  def profile_params
    request_params[:profile]
  end

  def sign_up_params
    request_params.except(:profile)
  end

  def request_params
    params.require(:user).permit(:email, :password, :password_confirmation, profile: [:phone, :email, :company_name, :contact_person, :profile_type])
  end
end
