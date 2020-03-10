class MailsForGroupJob < ApplicationJob
  queue_as :critical

  def perform(args)
    profile_type = args[:profile_type] == 'all' ? Profile::PROFILE_TYPES : args[:profile_type]

    User.joins(:profile).where(profiles: { profile_type: profile_type }).find_each(batch_size: 50) do |user|
      SendDirectMailJob.perform_now(user: user, subject: args[:subject], message: args[:message], method: 'custom_message')
    end
  end
end