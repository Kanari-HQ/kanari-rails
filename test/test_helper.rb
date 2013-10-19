require 'minitest/pride' # Coloring

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # if repeating "FactoryGirl" is too verbose, ie. create(:user) instead of FactoryGirl.create(:user)
  include FactoryGirl::Syntax::Methods
end
