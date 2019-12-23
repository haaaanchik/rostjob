# Be sure to restart your server when you modify this file.
# Rails.application.config.assets.precompile += %w[welcome not_authorized]
Rails.application.config.assets.precompile += %w( not_authorized.css secret_landing.css secret_landing.js )
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "images")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "videos")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
