require 'test_helper'

describe "An Event" do
  it "must aggregate votes" do
    event = create(:event)
    create(:vote, event: event, vote_type: "thumbs-up", created_at: "2013-10-19 11:10:17")
    create(:vote, event: event, vote_type: "thumbs-up", created_at: "2013-10-19 11:10:17")
    create(:vote, event: event, vote_type: "thumbs-up", created_at: "2013-10-19 11:10:18")
    create(:vote, event: event, vote_type: "thumbs-down", created_at: "2013-10-19 11:10:17")
    create(:vote, event: event, vote_type: "thumbs-down", created_at: "2013-10-19 11:10:17")
    create(:vote, event: event, vote_type: "thumbs-down", created_at: "2013-10-19 11:10:18")
    create(:vote, event: event, vote_type: "thumbs-up", created_at: "2013-10-19 11:10:17")
    create(:vote, event: event, vote_type: "thumbs-down", created_at: "2013-10-19 11:10:17")

    res = event.aggregate_votes

    res['title'].must_equal 'thumbs-up'
    res['points'].first['x']


    assert_equal true, false
    #assert_equal actual, false
    #@event.title.must_equal "kamil"
  end
end
