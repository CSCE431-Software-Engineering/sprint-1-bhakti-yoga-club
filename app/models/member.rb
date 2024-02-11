class Member < ApplicationRecord
	validates_email_format_of :email, message: "is not valid"

	has_many :attendances
	has_many :events, through: :attendances
end