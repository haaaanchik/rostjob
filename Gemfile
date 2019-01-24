source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

env = ENV.fetch("RAILS_ENV") {"development"}
if env == 'production'
  ruby "2.5.1"
end

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

gem "paperclip", git: "git://github.com/thoughtbot/paperclip.git"
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
gem 'capistrano-rails', require: false, group: :development
gem 'rvm1-capistrano3', require: false, group: :development

gem 'activerecord-session_store', '~> 1.1', '>= 1.1.1'
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

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test, :staging do
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
  gem 'annotate', '~> 2.7', '>= 2.7.2'
  gem 'rubocop', '~> 0.54.0', require: false
  gem 'rubocop-rspec'
  gem 'web-console', '~> 3.5', '>= 3.5.1'
end

group :production do
  unless Gem.win_platform?
    gem 'unicorn', '~> 5.4'
    gem 'unicorn-worker-killer', '~> 0.4.4'
  end
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
