require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    create(:event)
    @event = Event.where(title: 'Macbeth').first
  end

  def test_that_aggregating_works
    puts @event.attributes
    actual = @event.votes.to_a
    puts @event.votes.count
    assert_equal actual, false
  end
end
