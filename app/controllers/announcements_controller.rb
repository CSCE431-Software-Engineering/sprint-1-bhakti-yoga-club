# app/controllers/announcements_controller.rb
class AnnouncementsController < ApplicationController

  before_action :authenticate_member!, except: [:index, :show]
  before_action :set_announcement, only: [:show, :edit, :update, :destroy]

  def index
    @announcements = Announcement.order(message_date: :desc)
  end

  def show
  end

  def new
    @announcement = Announcement.new
  end

  def edit
  end


  def create
    @announcement = Announcement.new(announcement_params)

    @announcement.member_id = current_member.id
    @announcement.message_date = Time.current.in_time_zone('Central Time (US & Canada)')

    respond_to do |format|
      if @announcement.save

        # specific_member = Member.find_by(id: 2)

        # if specific_member
        #   Rails.logger.debug "Sending announcement email to specific member #{specific_member.id} (#{specific_member.email})..."
        #   AnnouncementMailer.send_announcement_email(specific_member, @announcement).deliver

        # else
        #   Rails.logger.warn "Specific member not found. No email sent."
        # end

        Member.all.each do |member|
          AnnouncementMailer.send_announcement_email(member, @announcement).deliver_now
        end

        format.html { redirect_to announcements_path, notice: 'Announcement created successfully!'}
      else
        Rails.logger.debug @announcement.errors.full_messages.join(', ')
        format.html { render :new, status: :unprocessable_entity, flash: { error: @announcement.errors.full_messages.join(', ') } }
      end
    end
  end

  
  def update
    @announcement = Announcement.find(params[:id])
  
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcements_path, notice: 'Announcement updated successfully!' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @announcement.destroy
  
    respond_to do |format|
      format.html { redirect_to announcements_path, notice: 'Announcement was successfully destroyed.' }
    end
  end

  private
  def set_announcement
    return unless params[:id]
    @announcement = Announcement.find(params[:id])
  end

  def announcement_params
    params.require(:announcement).permit(:message_title, :message_text, :message_date, :member_id)
  end

end
  