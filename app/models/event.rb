class Event < ApplicationRecord
	has_many :attendances
	has_many :members, through: :attendances
	has_many :budget_items
	has_many :announcements
  
	validates :name, presence: true
	validates :location, presence: true
	validates :start_date, presence: true
  	validates :end_date, presence: true
  end