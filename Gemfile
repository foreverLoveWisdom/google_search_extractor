source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

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

  # Combine 'pry' with 'byebug'. Adds 'step', 'next', 'finish', 'continue' and 'break' commands to control execution.
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'

  # Great Ruby debugging companion: pretty print Ruby objects to visualize their structure
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'

  # Use Pry as your rails console
  gem 'pry-rails', '~> 0.3.9'

  # rspec-rails is a testing framework for Rails 5+.
  gem 'rspec-rails', '~> 6.0', '>= 6.0.1'

  # Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem 'faker', '~> 3.1', '>= 3.1.1'

  # Factory Bot is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.
  gem 'factory_bot_rails', '~> 6.2'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Brakeman is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  gem 'brakeman', '~> 5.4'

  # bundler-audit provides patch-level verification for Bundled apps.
  gem 'bundler-audit', '~> 0.9.1'

  # Utility to install, configure, and extend Git hooks
  gem 'overcommit', '~> 0.60.0'

  # Guard is a command line tool to easily handle events on file system modifications.
  gem 'guard', '~> 2.18', require: false

  # Guard::RSpec automatically run your specs (much like autotest).
  gem 'guard-rspec', '~> 4.7', '>= 4.7.3', require: false

  # Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema.
  gem 'annotate', '~> 3.2'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "webdrivers"

  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock', '~> 3.18', '>= 3.18.1'

  # Strategies for cleaning databases. Can be used to ensure a clean slate for testing.
  gem 'database_cleaner-active_record', '~> 2.0', '>= 2.0.1'

  # Code coverage for Ruby with a powerful configuration library and automatic merging of coverage across test suites
  gem 'simplecov', '~> 0.22.0', require: false
end

# A RuboCop extension focused on enforcing Rails best practices and coding conventions.
gem 'rubocop-rails', require: false

# RSpec-specific analysis for your projects, as an extension to RuboCop.
gem 'rubocop-rspec', require: false

# Performance optimization analysis for your projects, as an extension to RuboCop.
gem 'rubocop-performance', require: false

# Easy way to build and manage commands (service objects)
gem 'simple_command', '~> 1.0', '>= 1.0.1'

# Haml-rails provides Haml generators for Rails 5, 6, and 7
gem 'haml-rails', '~> 2.1'

# Bundle and process CSS with Tailwind, Bootstrap, PostCSS, Sass in Rails via Node.js.
gem 'cssbundling-rails', '~> 1.1', '>= 1.1.2'

# Bundle and transpile JavaScript in Rails with esbuild, rollup.js, or Webpack.
gem 'jsbundling-rails', '~> 1.1', '>= 1.1.1'

# Makes it easy and painless to work with XML and HTML from Ruby
gem 'nokogiri', '~> 1.14', '>= 1.14.2'

# A flexible authentication solution for Rails based on Warden
gem 'devise', '~> 4.9'

# Validations for Active Storage (presence)
gem 'active_storage_validations', '~> 1.0', '>= 1.0.3'

# Implements the W3C WebDriver protocol to automate popular browsers
gem 'selenium-webdriver', '~> 4.8', '>= 4.8.1'

# JSON:API serialization, error handling, filtering and pagination.
gem 'jsonapi.rb', '~> 2.0', '>= 2.0.1'

# Enables the user to sign in via an authentication token
gem 'devise-token_authenticatable', '~> 1.1'
