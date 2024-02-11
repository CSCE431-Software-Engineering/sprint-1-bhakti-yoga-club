class Member < ApplicationRecord
	validates_email_format_of :email, message: "is not valid"

	has_many :attendances
	has_many :events, through: :attendances

	private

	def check_email_format
    unless ValidatesEmailFormatOf.validates_email_format(email)
      errors.add(:email, "is not valid")
    end
  end
end