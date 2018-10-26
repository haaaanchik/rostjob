Raven.configure do |config|
  # config.dsn = 'https://bf2b7ff5756c473e881749fc4c3ec519:aa4cbd4928da4cf297b2d8991684ca57@sentry.io/1212064'
  config.dsn = 'https://fa5c7d878b2e486ba398551eb84c0b79:70cee5a0e32c45afa6aef3e13d09c80b@sentry.io/1310110'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = %w[production]
end
