ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

# rake TESTOPTS='--seed=53594'
require "minitest/autorun"
require 'minitest/spec'
require 'minitest/unit'
require "minitest/focus"
require 'capybara/rails'
require 'active_support/testing/setup_and_teardown'

require 'factory_girl'
include FactoryGirl::Syntax::Methods # No longer need "FactoryGirl" to create factories

require 'rails/test_help'
ActiveRecord::Migration.check_pending!

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  register_spec_type /integration$/, self
end

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end

DatabaseCleaner.strategy = :transaction
class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

#Turn.config.format = :outline