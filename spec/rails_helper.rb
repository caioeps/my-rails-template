require 'simplecov'
require 'codeclimate-test-reporter'

ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE']
  SimpleCov.start 'rails' do
    minimum_coverage 90
    refuse_coverage_drop

    add_filter do |source_file|
      source_file.filename =~ %r{app/channels|lib/tasks}
    end
  end
else
  SimpleCov.start
  CodeClimate::TestReporter.start
end

require_relative '../config/environment'

if Rails.env.production? || Rails.env.staging?
  abort 'The Rails environment is running in production mode!'
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

if ENV['COVERAGE']
  %w(Controller Record Mailer Job).each do |klass|
    Object.const_get "Application#{klass}"
  end
end

require 'spec_helper'
require 'rspec/rails'
require 'capybara/poltergeist'

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :rack_test

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.include ActiveJob::TestHelper, type: :feature
  config.include MailerHelper

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before :each do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each, type: :feature do
    DatabaseCleaner.strategy = :truncation
  end

  config.around :each do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end

  config.before(:each) do |example|
    ActionMailer::Base.deliveries.clear
  end
end

