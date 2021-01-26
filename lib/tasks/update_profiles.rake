# frozen_string_literal: true

namespace :update_profile do
  desc 'added data partner'
  task contractor: :environment do
    Profile.where(profile_type: 'contractor').find_each(batch_size: 50) do |profile|
      next if profile.company

      Cmd::Profile::Company::PartnerCreate.call(profile: profile)
    end

    p 'Профили обновлены'
  end
end
