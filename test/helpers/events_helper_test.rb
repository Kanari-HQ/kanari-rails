require 'test_helper'

describe EventsHelper do
  it 'converts number to currency' do
    number_to_currency(5).must_equal "$5.00"
  end

  it "is being skipped" do
    skip "do this later"
  end
end
