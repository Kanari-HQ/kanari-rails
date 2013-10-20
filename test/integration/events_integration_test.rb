require 'test_helper'

describe "Events integration" do
  it "shows event name" do
    event = create(:event)
    visit event_path(event)
    page.text.must_include "Macbeth"
  end
end