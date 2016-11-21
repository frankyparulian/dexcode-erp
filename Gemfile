source 'https://rubygems.org'

ruby '2.1.5'

# Rails
gem 'rails', '4.1.1'

# Database
gem 'mysql2', '0.3.18'

# Assets
gem 'less-rails'
gem 'less-rails-bootstrap'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer'
gem 'jquery-rails'
gem 'jquery-raty-rails', github: 'bmc/jquery-raty-rails' # compatible on rails 4
gem 'jquery-ui-rails'
gem 'angularjs-rails', '~> 1.2.26'
gem 'angularjs-rails-resource'
gem 'angular-ui-bootstrap-rails', '0.12.0'
gem 'react-rails', github: 'reactjs/react-rails'
gem 'sprockets-coffee-react'
gem 'browserify-rails', '~> 0.7'
gem 'momentjs-rails'
gem 'bootstrap-daterangepicker-rails'
gem "select2-rails"
gem 'flot-rails', :git => "https://github.com/Kjarrigan/flot-rails.git"
gem 'axlsx' , :require => "axlsx"
gem 'axlsx_rails' , :require => "axlsx_rails"
gem "font-awesome-rails"
gem 'multipart-post' , require: 'net/http/post/multipart'
gem 'google_drive', require: "google_drive"
gem 'icheck-rails'

# Admin interface
# gem 'rails_admin'

# Form handling
gem 'nested_form'

# Image Uploader
gem 'carrierwave'

# Use for Count Business Time
gem 'business_time'

# Use money format for Rails
gem 'money-rails'

# PDF Generation
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

# User Authentication
gem 'devise'
gem 'devise_invitable'

# User Access System
gem "pundit"

# Scheduler
gem 'resque', require: 'resque/server'
gem 'resque-scheduler'
gem 'resque-web', require: 'resque_web'

# Server
gem 'puma'
gem 'foreman'

# Environment
gem 'dotenv-rails'

# Tree structure in ActiveRecord
gem 'ancestry'

# JSON serializers
gem 'active_model_serializers', '0.8.1'

gem 'google-api-client', :require => ['google/api_client','google/api_client/auth/installed_app','google/api_client/client_secrets','google/api_client/auth/storage','google/api_client/auth/storages/file_store']

gem 'omniauth'
gem 'omniauth-google-oauth2', :git => 'https://github.com/zquestz/omniauth-google-oauth2.git'

# For Api Authentication
gem 'doorkeeper', '~> 2.2.1'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  #gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'pry'
end

group :development do
  # Use Capistrano for deployment
  gem 'annotate'
  gem 'letter_opener'
  gem 'quiet_assets'

  gem 'capistrano', '3.2.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-resque', '~> 0.2.1', require: false
  gem 'capistrano3-foreman'

  gem 'yard'
end
