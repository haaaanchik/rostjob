# frozen_string_literal: true

class SendDirectMailJob < ApplicationJob
  queue_as :mail

  def perform(args)
    DirectMailMailer.with(user: args[:user],
                          email: args[:email],
                          subject: args[:subject],
                          message: args[:message],
                          attrs: args[:attrs])
      .public_send(args[:method]).deliver_now
  end
end
