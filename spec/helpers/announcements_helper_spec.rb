require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AnnouncementsHelper. For example:
#
# describe AnnouncementsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AnnouncementsHelper, type: :helper do
  it "formats announcement text" do
    announcement = double("Announcement", message_text: "Hello, world!")
    formatted_text = helper.format_announcement_text(announcement)
    expect(formatted_text).to eq("<p>Hello, world!</p>")
  end
end
