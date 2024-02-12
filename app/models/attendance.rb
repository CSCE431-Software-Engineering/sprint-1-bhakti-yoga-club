class Attendence < ApplicationRecord
	belongs_to :member
	belongs_to :event

	validates :time_arrived, presence: true
	validates :time_departed, presence: true
end