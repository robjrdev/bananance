class User < ApplicationRecord
	include BCrypt
	validates :first_name, presence: true, length: { maximum: 50 }
	validates :last_name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: URI::MailTo::EMAIL_REGEXP },
					  uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 5 }

	def password
		@password
	end
	def password=(raw)
		@password = raw
		self.password_digest = Password.create(raw)
	end

	def is_password?(raw)
		Password.new(password_digest).is_password?(raw)
	end
end