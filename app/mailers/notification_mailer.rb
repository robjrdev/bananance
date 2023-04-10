class NotificationMailer < ApplicationMailer
  def new_user(user)
    @user = user

    # Send email to the user
    mail(to: @user.email, subject: 'Welcome to My Awesome App')
  end

  def admin_notification(user)
    @user = user
    admins = User.where(admin: true)

    # Send email to all admins
    admins.each do |admin|
      mail(to: admin.email, subject: 'New User Created')
    end
  end

	def pending(user)
		@user = user
		mail(to: @user.email, subject: 'Review')
	end

	def approved(user)
		@user = user
		mail(to: @user.email, subject: 'Congratulations! Your approved!')
	end
end
