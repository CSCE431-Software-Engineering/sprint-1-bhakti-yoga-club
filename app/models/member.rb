class Member < ApplicationRecord

	devise :omniauthable, omniauth_providers: [:google_oauth2]

  validates :email, format: { with: /\A(?:@gmail\.com|@tamu\.edu)\z/, message: "is not from an allowed domain" }

	validates_email_format_of :email, message: "is not valid"

	has_many :attendances
	has_many :events, through: :attendances

	private

	def check_email_format
    unless ValidatesEmailFormatOf.validates_email_format(email)
      errors.add(:email, "is not valid")
    end
  end

  def self.from_google(email:, full_name:, date_joined:)
    # return nil unless email =~ /@mybusiness.com\z/
    create_with(full_name: full_name, date_joined: date_joined).find_or_create_by!(email: email)
  end
end