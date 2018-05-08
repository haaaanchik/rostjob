module UserProfile
  class Create
    include Interactor

    def call
      profile_context = context.context
      profile_params = context.profile_params
      photo = URI.parse(profile_params[:photo_url])
      profile = Profile.new(profile_params.except(:photo_url))
      if profile_context
        profile.save(context: profile_context)
      else
        profile.save
      end
      if profile.persisted?
        profile.photo = photo
        profile.save
        context.profile = profile
      else
        context.fail!(message: "#{profile.errors}")
      end
    end
  end
end
