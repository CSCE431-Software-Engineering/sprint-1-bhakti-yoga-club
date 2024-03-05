require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AttendancesHelper. For example:
#
# describe AttendancesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AttendancesHelper, type: :helper do
  it "formats attendance text" do
    attendance = double("Attendance", member_id: 1, event_id: 1, time_arrived: DateTime.new(2024,4,5,4,5,6), time_departed: DateTime.new(2024,4,5,5,5,6))
    formatted_text = helper.format_attendance_text(attendance)
    expect(formatted_text).to eq("<p> Member ID: #{attendance.member_id}<br>
    Event ID: #{attendance.event_id} <br>
    Arrived at: #{attendance.time_arrived} <br>
    Departed at: #{attendance.time_departed}<br><br></p>")
  end
end