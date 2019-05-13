class CreateDemoDataJob < ApplicationJob
  queue_as :critical

  def perform(args)
    Cmd::User::DemoData::Create.call(profile: args[:profile])
  end
end
