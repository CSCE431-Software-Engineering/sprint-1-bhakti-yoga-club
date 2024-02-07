class Event < ApplicationRecord
	has_many :attendences
	has_many :members, through: :attendences
	has_many :budget_items
	has_many :announcements
end