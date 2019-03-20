require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BestHr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    require 'search_app'
    config.middleware.use SearchApp
    config.time_zone = 'Moscow'

    config.i18n.default_locale = :ru
    config.i18n.locale = :ru
    config.i18n.load_path += Dir[Rails.root.join('config',
                                                 'locales', '**', '*.{rb,yml}')]
    config.encoding = 'utf-8'
    config.filter_parameters << :password

    # Don't generate system test files.
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.system_tests = nil
      g.view_specs        false
      g.helper_specs      false
      g.controller_specs  true
      g.integration_specs false
      g.stylesheets  true
      g.javascripts  true
      g.helper       true
    end
    config.active_job.queue_adapter = :resque
    config.email_to = 'alkos.network@gmail.com, yusupov_ilshat@mail.ru'
    config.user_action_log = true
  end
end
