class Member < ApplicationRecord
	has_many :attendances
	has_many :events, through: :attendances
end