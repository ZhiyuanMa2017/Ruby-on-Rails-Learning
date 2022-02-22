class User < ApplicationRecord
  before_save { self.email = email.downcase }
  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  validates :phone_number, presence: true, :if => lambda { self.teacher == false }
  validates :major, presence: true, :if => lambda { self.teacher == false }, on: :create
  validates :birthday, presence: true, :if => lambda { self.teacher == false }, on: :create
  validate :birthday_validation

  validates :department, presence: true, :if => lambda { self.teacher == true }

  has_many :enrollments, dependent: :destroy

  has_many :courses, through: :enrollments, dependent: :destroy

  has_many :teaching_courses, class_name: 'Course', foreign_key: 'teacher_id'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  def birthday_validation
    unless birthday.nil?
      if birthday > Date.today
        errors.add(:birthday, 'must be in the past')
      end
    end

  end

  has_secure_password

  def User.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def user_remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def user_forget
    update_attribute(:remember_digest, nil)
  end

  def user_authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  private

  def user_downcase_email
    self.email = email.downcase
  end
end
