source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem 'sassc-rails'
gem "tzinfo-data"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "pry"
  gem 'faker'  
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem 'database_cleaner-active_record'
  gem 'shoulda-matchers'
  # gem "selenium-webdriver"
end

# Use devise for user management
gem 'devise'
