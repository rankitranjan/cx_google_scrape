require 'playwright'

RSpec.configure do |config|
  # Clean DB before running tests
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each) do
    allow(Playwright).to receive(:create).and_return(double("PlaywrightInstance"))
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    Sidekiq::Worker.clear_all # Clear Sidekiq queue before each test
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
