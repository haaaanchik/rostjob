module UserProfile
  class Create
    include Interactor

    def call
      profile_params = context.profile_params
      photo = URI.parse(profile_params[:photo_url]) if profile_params[:photo_url]
      profile = Profile.new(profile_params.except(:photo_url).merge(photo: photo))
      profile.enable_sm_registration_validation if context.sm_registration
      profile.fill unless context.sm_registration
      profile.save
      if profile.persisted?
        profile.create_balance
        context.profile = profile
      end
      context.fail!(messages: profile.errors.messages) unless profile.persisted?
    end
  end
end
