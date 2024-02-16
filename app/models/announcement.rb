class Announcement < ApplicationRecord
	belongs_to :member
  
	validates :message_title, presence: true
	validates :message_text, presence: true
	validates :message_date, presence: true
  end
  