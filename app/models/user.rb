class User < ApplicationRecord
  include BCrypt

  attr_accessor :password_confirmation

  has_many :user_stocks, dependent: :delete_all
  has_many :stocks, through: :user_stocks
  has_many :transactions, dependent: :destroy
  has_many :fiats, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 20 }
  validates :last_name, presence: true, length: { maximum: 20 }
  validates :email,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
            },
            uniqueness: {
              case_sensitive: false,
            }
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true, on: :create
  validate :passwords_match

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

  def passwords_match
    if password != password_confirmation
      errors.add(:password_confirmation, 'does not match Password')
    end
  end

  def is_admin?
    self.admin == true
  end

  def send_notifications
    NotificationMailer.new_user(self).deliver_later
    NotificationMailer.pending(self).deliver_later
    NotificationMailer.admin_notification(self).deliver_later
  end

  def update_status
    if status == 'pending'
      update_attribute(:status, 'approved')
      NotificationMailer.approved(self).deliver_later
      true
    elsif update_attribute(:status, 'pending')
      true
    else
      false
    end
  end
end
