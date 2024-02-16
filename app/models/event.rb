class Event < ApplicationRecord
	has_many :attendances
	has_many :members, through: :attendances
	has_many :budget_items
	has_many :announcements
  
	validates :name, presence: true
	validates :date, presence: true
	validates :location, presence: true
  end