
class Event < ApplicationRecord
	has_many :attendances
	has_many :members, through: :attendances
	has_many :budget_items
	has_many :announcements
  
	validates :name, presence: true
	validates :location, presence: true
	validates :start_time, presence: true
  	validates :end_time, presence: true
	validate :end_time_after_start_time
  
	  private
	  
	  def end_time_after_start_time
		if start_time && end_time && end_time <= start_time
		  errors.add(:end_time, "must be after the start date")
		end
	  end
