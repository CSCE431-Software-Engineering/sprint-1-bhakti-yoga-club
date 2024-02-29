require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @events = [
      Event.create!(
        name: "Name",
        location: "Location",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour
      ),
      Event.create!(
        name: "Name",
        location: "Location",
        start_time: DateTime.now,
        end_time: DateTime.now + 1.hour
      )
    ]
    assign(:events, @events)
  end

  it "renders a list of events" do
    render
    assert_select ".card-header .card-title a", text: "Name", count: 2
    assert_select ".card-body .card-text", text: "Location", count: 2
  end
end
