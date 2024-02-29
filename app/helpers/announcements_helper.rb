module AnnouncementsHelper
def format_announcement_text(announcement)
# Define your formatting logic here
"<p>#{announcement.message_text}</p>"
end
end