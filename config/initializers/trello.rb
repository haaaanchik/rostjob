require 'trello'

Trello.configure do |config|
  config.developer_public_key = Rails.application.credentials.trello[:developer_public_key]
  config.member_token = Rails.application.credentials.trello[:member_token]
end
