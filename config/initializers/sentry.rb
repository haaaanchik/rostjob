Raven.configure do |config|
  config.dsn = 'https://bf2b7ff5756c473e881749fc4c3ec519:aa4cbd4928da4cf297b2d8991684ca57@sentry.io/1212064'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = %w[ production ]
end
