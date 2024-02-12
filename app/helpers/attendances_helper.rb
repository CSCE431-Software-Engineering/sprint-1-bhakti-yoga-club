module AttendancesHelper
  def format_attendance_text(attendance)
    # Define your formatting logic here
    "<p> Member ID: #{attendance.member_id}<br>
    Event ID: #{attendance.event_id} <br>
    Arrived at: #{attendance.time_arrived} <br>
    Departed at: #{attendance.time_departed}<br><br></p>"
  end
end