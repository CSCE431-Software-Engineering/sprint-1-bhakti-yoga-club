# app/controllers/announcements_controller.rb
class AnnouncementsController < ApplicationController

    def index
      @announcements = Announcement.order(message_date: :desc)
    end
  
    def new
      @announcement = Announcement.new

    end


    def create
        @announcement = Announcement.new(announcement_params)

        @announcement.member_id = 1
        @announcement.message_date = Time.current


        respond_to do |format|
            if @announcement.save
            format.html { redirect_to announcements_url, notice: 'Announcement created successfully!' }
            format.json { render :show, status: :created, location: @announcement }
            else
            Rails.logger.debug @announcement.errors.full_messages.join(', ')
            format.html { render :new, status: :unprocessable_entity, flash: { error: @announcement.errors.full_messages.join(', ') } }
            format.json { render json: @announcement.errors, status: :unprocessable_entity }
            end
        end
    end
  
    private
  
    def announcement_params
      params.require(:announcement).permit(:message_text, :message_date, :member_id)
    end
  
  end
  