require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'

require 'sidekiq/testing'
Sidekiq::Testing.inline!

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.before(:each, type: :feature) { Warden.test_mode! }
  config.after(:each, type: :feature) { Warden.test_reset! }

  config.include FactoryBot::Syntax::Methods

  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.include Devise::Test::IntegrationHelpers, type: :request

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
