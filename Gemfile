source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

env = ENV.fetch("RAILS_ENV") {"development"}
if env == 'production'
  ruby "2.5.1"
end

gem "dry-validation"
gem 'mailgun_rails', git: 'https://github.com/kosorotov/mailgun_rails.git', branch: 'master'
gem 'mailgun-ruby', require: 'mailgun'
gem 'select2-rails', '~> 4.0', '>= 4.0.3'
gem 'rest-client'
gem 'strip_attributes', '~> 1.9'
gem 'data-confirm-modal'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'jquery-inputmask-rails'
gem 'draper'
gem 'rubyzip'
gem 'axlsx'
gem 'axlsx_rails'
gem 'phonelib'
gem 'validates'
gem 'rails-i18n'
gem 'client_bank_exchange'
gem 'kaminari'
gem 'prawn'
gem 'prawn-table'
gem 'ru_propisju'
gem 'ruby-trello'
gem 'sitemap_generator'
gem 'email_validator'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5.1'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.1', '>= 4.1.10'
# See https://github.com/rails/execjs#readme for more supported runtimes
# # VERY BUGGY!
#gem 'duktape'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

#AUTH ->
gem 'devise', '~> 4.5'
gem 'omniauth', '~> 1.8', '>= 1.8.1'
gem 'omniauth-facebook', '~> 5.0'
gem 'omniauth-vkontakte', '~> 1.4', '>= 1.4.1'
gem 'omniauth-google-oauth2', '~> 0.5.3'
gem 'omniauth-mail_ru', '~> 1.1'
gem 'activerecord-session_store', '~> 1.1', '>= 1.1.1'
#AUTH  <-
gem 'conditional_validation'
gem 'sentry-raven'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem 'royce'
gem "resque"
gem "resque-scheduler"
gem 'resque-web', github: 'resque/resque-web', branch: 'master', require: 'resque_web'
gem "redis"
gem "redis-objects"
gem "active_scheduler"
gem "recaptcha"
gem 'active_link_to'

gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
gem 'capistrano-rails', require: false, group: :development
gem 'rvm1-capistrano3', require: false, group: :development

gem 'russian', '~> 0.6.0'
gem 'petrovich', '~> 1.1', '>= 1.1.1'

gem 'slim', '~> 3.0', '>= 3.0.9'
gem 'slim-rails', '~> 3.1', '>= 3.1.3'
gem 'html2slim'

gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'jquery-turbolinks', '~> 2.1'
gem 'enumerize'
gem "interactor"
gem 'aasm'
gem 'faker'
gem 'decent_exposure', '3.0.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test, :staging, :production do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-rails"
  gem "pry-awesome_print"
  gem 'pry-byebug', '~> 3.6'
  gem "pry-inline"
  gem "pry-rescue"
  gem "pry-alias"
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rails-erd'
  gem 'i18n-debug'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'web-console', '~> 3.5', '>= 3.5.1'
  gem 'letter_opener', '~> 1.7'
end

group :production do
  unless Gem.win_platform?
    gem 'unicorn', '~> 5.4'
    gem 'unicorn-worker-killer', '~> 0.4.4'
  end
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'premailer-rails', '~> 1.10', '>= 1.10.3'
gem 'high_voltage', '~> 3.1'
gem 'lightbox2-rails', '~> 2.8', '>= 2.8.2.1'
gem 'clipboard-rails', '~> 1.7', '>= 1.7.1'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'