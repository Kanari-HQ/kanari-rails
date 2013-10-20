ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)

# rake TESTOPTS='--seed=53594'
require "minitest/autorun"
require 'capybara/rails'
require 'active_support/testing/setup_and_teardown'
require 'minitest/pride' # Coloring


require 'factory_girl'
# if repeating "FactoryGirl" is too verbose, ie. create(:user) instead of FactoryGirl.create(:user)
include FactoryGirl::Syntax::Methods


require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end

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

Turn.config.format = :outline