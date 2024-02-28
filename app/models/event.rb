class Event < ApplicationRecord
	has_many :attendances
	has_many :members, through: :attendances
	has_many :budget_items
	has_many :announcements
  
	validates :name, presence: true
	validates :location, presence: true
	validates :start_date, presence: true
  	validates :end_date, presence: true
	validate :end_date_after_start_date
  
	  private
	  
	  def end_date_after_start_date
		if start_date && end_date && end_date <= start_date
		  errors.add(:end_date, "must be after the start date")
		end
	  end
  end