class AnnouncementMailer < ApplicationMailer
    default from: 'byc.notifs@gmail.com'
    def send_announcement_email(member, announcement)
        @member = member
        @announcement = announcement
        mail(to: @member.email, subject: 'New Announcement from Bhakti Yoga Club!')
    end
end
