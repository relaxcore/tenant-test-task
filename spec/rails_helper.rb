ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
require 'spec_helper'
require 'rspec/rails'
require 'factory_bot_rails'
require 'shoulda/matchers'

Rails.application.load_tasks

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.around(:each, use_transaction: false) do |example|
    self.use_transactional_tests = false
    example.run
    self.use_transactional_tests = true
  end

  config.after do
    Current.reset
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
