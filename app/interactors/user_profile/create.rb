module UserProfile
  class Create
    include Interactor

    def call
      profile_context = context.context
      profile_params = context.profile_params
      profile = Profile.new(profile_params)
      if profile_context
        profile.save(context: profile_context)
      else
        profile.save
      end
      if profile.persisted?
        context.profile = profile
      else
        context.fail!(message: "#{profile.errors}")
      end
    end
  end
end
