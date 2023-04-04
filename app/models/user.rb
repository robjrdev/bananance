class User < ApplicationRecord
	include BCrypt
	validates :first_name, presence: true, length: { maximum: 20 }
	validates :last_name, presence: true, length: { maximum: 20 }
	validates :email, presence: true,
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