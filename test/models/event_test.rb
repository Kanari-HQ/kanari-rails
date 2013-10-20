require 'test_helper'

describe Event do
  it "must aggregate votes" do
    create(:event)
    @event = Event.where(title: 'Macbeth').first

    puts @event.attributes
    actual = @event.votes.to_a
    puts @event.votes.count
    assert_equal actual, false
    @event.title.must_equal "kamil"
  end
end
