source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8", ">= 7.0.8.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #Add Capistrano for deploy
  gem "capistrano", "~> 3.10", require: false
  gem 'capistrano-bundler', '~> 1.5'
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rake', require: false
  gem 'capistrano-rvm', require: false
  gem 'sshkit-sudo'
  gem 'capistrano3-unicorn'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"

end

gem "camaleon_cms", github: 'papayalabs/camaleon-cms-7' #path: "/Users/papayalabs/Github/camaleon-cms" #' # latest development version 


#################### Camaleon CMS include all gems for plugins and themes #################### 
require_relative './lib/plugin_routes' 
instance_eval(PluginRoutes.draw_gems)

gem 'unicorn-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'draper', '>= 3' # for Rails 5+
gem 'jquery-rails' 
gem 'jquery-ui-rails'
gem "select2-rails"

#For Capistrano SSH
gem 'net-ssh', '>= 6.0.2'
gem 'ed25519', '>= 1.4', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'

#Databases
gem 'pg', '>= 1.1'
gem "sqlite3", "~> 1.4"
